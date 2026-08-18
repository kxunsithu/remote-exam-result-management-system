package server;

import common.ExamResult;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for ExamResult operations.
 * All queries use JOINs to populate student and subject display fields.
 */
public class ExamResultDAO {

    private static final String SELECT_WITH_JOINS = """
        SELECT er.id, er.student_id, er.subject_id, er.marks, er.total_marks,
               er.grade, er.academic_year, er.semester, er.created_at,
               s.name AS student_name, s.student_id AS student_code,
               sub.subject_name, sub.subject_code
        FROM exam_results er
        JOIN students s ON er.student_id = s.id
        JOIN subjects sub ON er.subject_id = sub.id
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
        String sql = SELECT_WITH_JOINS + " WHERE er.student_id = ? ORDER BY sub.subject_code";
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
                                    String semester, String academicYear) {
        List<ExamResult> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder(SELECT_WITH_JOINS + " WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (studentId != null && !studentId.isBlank()) {
            sb.append(" AND er.student_id = ?");
            params.add(Integer.parseInt(studentId.trim()));
        }
        if (subjectId != null && !subjectId.isBlank()) {
            sb.append(" AND er.subject_id = ?");
            params.add(Integer.parseInt(subjectId.trim()));
        }
        if (semester != null && !semester.isBlank()) {
            sb.append(" AND er.semester = ?");
            params.add(Integer.parseInt(semester.trim()));
        }
        if (academicYear != null && !academicYear.isBlank()) {
            sb.append(" AND er.academic_year = ?");
            params.add(academicYear.trim());
        }
        sb.append(" ORDER BY er.created_at DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else ps.setString(i + 1, (String) p);
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
            INSERT INTO exam_results (student_id, subject_id, marks, total_marks, grade, academic_year, semester)
            VALUES (?, ?, ?, ?, ?, ?, ?)
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
            UPDATE exam_results SET student_id=?, subject_id=?, marks=?, total_marks=?,
                grade=?, academic_year=?, semester=?
            WHERE id=?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setResultParams(ps, r);
            ps.setInt(8, r.getId());
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

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM exam_results")) {
            return rs.getInt(1);
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
        ps.setString(6, r.getAcademicYear());
        ps.setInt(7, r.getSemester());
    }

    private ExamResult mapRow(ResultSet rs) throws SQLException {
        ExamResult er = new ExamResult(
            rs.getInt("id"),
            rs.getInt("student_id"),
            rs.getInt("subject_id"),
            rs.getDouble("marks"),
            rs.getDouble("total_marks"),
            rs.getString("grade"),
            rs.getString("academic_year"),
            rs.getInt("semester"),
            LocalDateTime.parse(rs.getString("created_at").replace(" ", "T"))
        );
        er.setStudentName(rs.getString("student_name"));
        er.setStudentCode(rs.getString("student_code"));
        er.setSubjectName(rs.getString("subject_name"));
        er.setSubjectCode(rs.getString("subject_code"));
        return er;
    }
}
