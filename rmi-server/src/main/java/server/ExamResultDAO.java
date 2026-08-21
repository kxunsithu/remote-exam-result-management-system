package server;

import common.ExamResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for ExamResult operations.
 * Academic year and semester are derived from the subject via JOINs.
 * All queries use JOINs to populate student and subject display fields.
 */
public class ExamResultDAO {

    private static final String SELECT_WITH_JOINS = """
        SELECT er.id, er.student_id, er.subject_id, er.marks, er.total_marks,
               er.grade, er.exam_type, er.created_at,
               s.name AS student_name, s.student_id AS student_code,
               sub.subject_name, sub.subject_code, sub.credit AS subject_credit,
               sub.semester_id, sm.semester_number, sm.academic_year_id,
               ay.year_name AS academic_year_name
        FROM exam_results er
        JOIN students s       ON er.student_id = s.id
        JOIN subjects sub     ON er.subject_id = sub.id
        JOIN semesters sm     ON sub.semester_id = sm.id
        JOIN academic_years ay ON sm.academic_year_id = ay.id
        """;

    public List<ExamResult> findAll() {
        List<ExamResult> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + " ORDER BY er.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public List<ExamResult> findRecent(int limit) {
        List<ExamResult> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + " ORDER BY er.created_at DESC LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.findRecent error: " + e.getMessage());
        }
        return list;
    }

    public List<ExamResult> findByStudentDbId(int studentDbId) {
        List<ExamResult> list = new ArrayList<>();
        String sql = SELECT_WITH_JOINS + """
            WHERE er.student_id = ?
            ORDER BY ay.year_name, sm.semester_number, sub.subject_code
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentDbId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.findByStudentDbId error: " + e.getMessage());
        }
        return list;
    }

    public ExamResult findById(int id) {
        String sql = SELECT_WITH_JOINS + " WHERE er.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    public List<ExamResult> search(String studentId, String subjectId,
                                    String semesterId, String academicYearId) {
        List<ExamResult> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder(SELECT_WITH_JOINS + " WHERE 1=1");
        List<Integer> params = new ArrayList<>();

        if (studentId != null && !studentId.isBlank()) {
            sb.append(" AND er.student_id = ?");
            params.add(Integer.parseInt(studentId.trim()));
        }
        if (subjectId != null && !subjectId.isBlank()) {
            sb.append(" AND er.subject_id = ?");
            params.add(Integer.parseInt(subjectId.trim()));
        }
        if (semesterId != null && !semesterId.isBlank()) {
            sb.append(" AND sub.semester_id = ?");
            params.add(Integer.parseInt(semesterId.trim()));
        }
        if (academicYearId != null && !academicYearId.isBlank()) {
            sb.append(" AND sm.academic_year_id = ?");
            params.add(Integer.parseInt(academicYearId.trim()));
        }
        sb.append(" ORDER BY er.created_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setInt(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.search error: " + e.getMessage());
        }
        return list;
    }

    public boolean insert(ExamResult r) {
        String sql = """
            INSERT INTO exam_results (student_id, subject_id, marks, total_marks, grade, exam_type)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setResultParams(ps, r);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(ExamResult r) {
        String sql = """
            UPDATE exam_results SET student_id=?, subject_id=?, marks=?, total_marks=?, grade=?, exam_type=?
            WHERE id=?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setResultParams(ps, r);
            ps.setInt(7, r.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM exam_results WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ExamResultDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Duplicate check: same student + same subject + same exam type.
     * The academic year/semester are implied by the subject.
     */
    public boolean existsDuplicate(int studentId, int subjectId, String examType, int excludeId) {
        String sql = "SELECT COUNT(*) FROM exam_results WHERE student_id = ? AND subject_id = ? AND exam_type = ? AND id != ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, examType != null && !examType.isBlank() ? examType : "REGULAR");
            ps.setInt(4, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM exam_results")) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    private void setResultParams(PreparedStatement ps, ExamResult r) throws SQLException {
        ps.setInt(1, r.getStudentId());
        ps.setInt(2, r.getSubjectId());
        ps.setDouble(3, r.getMarks());
        ps.setDouble(4, r.getTotalMarks());
        ps.setString(5, r.getGrade());
        ps.setString(6, r.getExamType() != null && !r.getExamType().isBlank() ? r.getExamType() : "REGULAR");
    }

    private ExamResult mapRow(ResultSet rs) throws SQLException {
        String examType = "REGULAR";
        try {
            String et = rs.getString("exam_type");
            if (et != null && !et.isBlank()) examType = et;
        } catch (SQLException ignored) {}

        ExamResult er = new ExamResult(
            rs.getInt("id"),
            rs.getInt("student_id"),
            rs.getInt("subject_id"),
            rs.getDouble("marks"),
            rs.getDouble("total_marks"),
            rs.getString("grade"),
            examType,
            AcademicYearDAO.parseDate(rs.getString("created_at"))
        );
        // Display fields derived from the subject's semester/academic year
        er.setAcademicYearId(rs.getInt("academic_year_id"));
        er.setAcademicYear(rs.getString("academic_year_name"));
        er.setSemesterId(rs.getInt("semester_id"));
        er.setSemester(rs.getInt("semester_number"));
        er.setStudentName(rs.getString("student_name"));
        er.setStudentCode(rs.getString("student_code"));
        er.setSubjectName(rs.getString("subject_name"));
        er.setSubjectCode(rs.getString("subject_code"));
        er.setSubjectCredit(rs.getInt("subject_credit"));
        return er;
    }
}
