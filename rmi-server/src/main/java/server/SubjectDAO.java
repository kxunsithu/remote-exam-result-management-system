package server;

import common.Subject;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Subject operations.
 */
public class SubjectDAO {

    private static final String SELECT_ALL = """
        SELECT id, subject_code, subject_name, credit, department, semester, created_at
        FROM subjects
        """;

    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL + " ORDER BY subject_code")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public List<Subject> search(String keyword) {
        List<Subject> list = new ArrayList<>();
        String q = "%" + keyword.toLowerCase() + "%";
        String sql = SELECT_ALL + """
            WHERE lower(subject_code) LIKE ? OR lower(subject_name) LIKE ?
               OR lower(department) LIKE ?
            ORDER BY subject_code
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q); ps.setString(2, q); ps.setString(3, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("SubjectDAO.search error: " + e.getMessage());
        }
        return list;
    }

    public Subject findById(int id) {
        String sql = SELECT_ALL + " WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Subject s) {
        String sql = """
            INSERT INTO subjects (subject_code, subject_name, credit, department, semester)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setSubjectParams(ps, s);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(Subject s) {
        String sql = """
            UPDATE subjects SET subject_code=?, subject_name=?, credit=?, department=?, semester=?
            WHERE id=?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setSubjectParams(ps, s);
            ps.setInt(6, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM subjects WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM subjects")) {
            return rs.getInt(1);
        } catch (SQLException e) {
            return 0;
        }
    }

    private void setSubjectParams(PreparedStatement ps, Subject s) throws SQLException {
        ps.setString(1, s.getSubjectCode());
        ps.setString(2, s.getSubjectName());
        ps.setInt(3, s.getCredit());
        ps.setString(4, s.getDepartment());
        ps.setInt(5, s.getSemester());
    }

    private Subject mapRow(ResultSet rs) throws SQLException {
        String cat = rs.getString("created_at");
        return new Subject(
            rs.getInt("id"),
            rs.getString("subject_code"),
            rs.getString("subject_name"),
            rs.getInt("credit"),
            rs.getString("department"),
            rs.getInt("semester"),
            cat != null ? LocalDateTime.parse(cat.replace(" ", "T")) : LocalDateTime.now()
        );
    }
}
