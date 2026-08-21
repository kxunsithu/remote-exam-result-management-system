package server;

import common.AcademicYear;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for AcademicYear operations.
 */
public class AcademicYearDAO {

    private static final String SELECT_ALL = """
        SELECT ay.id, ay.year_name, ay.created_at,
               (SELECT COUNT(*) FROM semesters sm WHERE sm.academic_year_id = ay.id) AS semester_count,
               (SELECT COUNT(*) FROM subjects sub
                  JOIN semesters sm2 ON sub.semester_id = sm2.id
                 WHERE sm2.academic_year_id = ay.id) AS subject_count
        FROM academic_years ay
        """;

    public List<AcademicYear> findAll() {
        List<AcademicYear> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL + " ORDER BY ay.year_name")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public AcademicYear findById(int id) {
        String sql = SELECT_ALL + " WHERE ay.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    public AcademicYear findByName(String yearName) {
        String sql = SELECT_ALL + " WHERE lower(ay.year_name) = lower(?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, yearName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.findByName error: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(AcademicYear y) {
        String sql = "INSERT INTO academic_years (year_name) VALUES (?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, y.getYearName().trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(AcademicYear y) {
        String sql = "UPDATE academic_years SET year_name = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, y.getYearName().trim());
            ps.setInt(2, y.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM academic_years WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("AcademicYearDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM academic_years")) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    private AcademicYear mapRow(ResultSet rs) throws SQLException {
        AcademicYear y = new AcademicYear(
            rs.getInt("id"),
            rs.getString("year_name"),
            parseDate(rs.getString("created_at"))
        );
        y.setSemesterCount(rs.getInt("semester_count"));
        y.setSubjectCount(rs.getInt("subject_count"));
        return y;
    }

    static LocalDateTime parseDate(String raw) {
        if (raw == null) return LocalDateTime.now();
        try {
            return LocalDateTime.parse(raw.replace(" ", "T"));
        } catch (Exception e) {
            return LocalDateTime.now();
        }
    }
}
