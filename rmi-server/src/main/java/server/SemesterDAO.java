package server;

import common.Semester;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Semester operations.
 */
public class SemesterDAO {

    private static final String SELECT_ALL = """
        SELECT sm.id, sm.academic_year_id, sm.semester_number, sm.created_at,
               ay.year_name AS academic_year_name,
               (SELECT COUNT(*) FROM subjects sub WHERE sub.semester_id = sm.id) AS subject_count
        FROM semesters sm
        JOIN academic_years ay ON sm.academic_year_id = ay.id
        """;

    public List<Semester> findAll() {
        List<Semester> list = new ArrayList<>();
        String sql = SELECT_ALL + " ORDER BY ay.year_name, sm.semester_number";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("SemesterDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public List<Semester> findByAcademicYear(int academicYearId) {
        List<Semester> list = new ArrayList<>();
        String sql = SELECT_ALL + " WHERE sm.academic_year_id = ? ORDER BY sm.semester_number";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, academicYearId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("SemesterDAO.findByAcademicYear error: " + e.getMessage());
        }
        return list;
    }

    public Semester findById(int id) {
        String sql = SELECT_ALL + " WHERE sm.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("SemesterDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Returns the semester row for a given (academic year, semester number) pair, or null.
     */
    public Semester findUnique(int academicYearId, int semesterNumber) {
        String sql = SELECT_ALL + " WHERE sm.academic_year_id = ? AND sm.semester_number = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, academicYearId);
            ps.setInt(2, semesterNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("SemesterDAO.findUnique error: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Semester s) {
        String sql = "INSERT INTO semesters (academic_year_id, semester_number) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getAcademicYearId());
            ps.setInt(2, s.getSemesterNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SemesterDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(Semester s) {
        String sql = "UPDATE semesters SET academic_year_id = ?, semester_number = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, s.getAcademicYearId());
            ps.setInt(2, s.getSemesterNumber());
            ps.setInt(3, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SemesterDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM semesters WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SemesterDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM semesters")) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    private Semester mapRow(ResultSet rs) throws SQLException {
        Semester s = new Semester(
            rs.getInt("id"),
            rs.getInt("academic_year_id"),
            rs.getInt("semester_number"),
            AcademicYearDAO.parseDate(rs.getString("created_at"))
        );
        s.setAcademicYearName(rs.getString("academic_year_name"));
        s.setSubjectCount(rs.getInt("subject_count"));
        return s;
    }
}
