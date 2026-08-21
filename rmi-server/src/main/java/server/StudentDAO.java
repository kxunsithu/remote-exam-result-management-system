package server;

import common.Student;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Student operations.
 */
public class StudentDAO {

    private static final String SELECT_ALL = """
        SELECT id, student_id, name, email, phone, gender, created_at
        FROM students
        """;

    public List<Student> findAll() {
        List<Student> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL + " ORDER BY student_id")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {
            System.err.println("StudentDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    public List<Student> search(String keyword) {
        List<Student> list = new ArrayList<>();
        String q = "%" + keyword.toLowerCase() + "%";
        String sql = SELECT_ALL + """
            WHERE lower(student_id) LIKE ? OR lower(name) LIKE ?
               OR lower(email) LIKE ?
            ORDER BY student_id
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q); ps.setString(2, q);
            ps.setString(3, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            System.err.println("StudentDAO.search error: " + e.getMessage());
        }
        return list;
    }

    public Student findById(int id) {
        String sql = SELECT_ALL + " WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    public Student findByStudentId(String studentId) {
        String sql = SELECT_ALL + " WHERE student_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.findByStudentId error: " + e.getMessage());
        }
        return null;
    }

    public Student findByEmail(String email) {
        String sql = SELECT_ALL + " WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.findByEmail error: " + e.getMessage());
        }
        return null;
    }

    public boolean insert(Student s) {
        String sql = """
            INSERT INTO students (student_id, name, email, phone, gender)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setStudentParams(ps, s);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(Student s) {
        String sql = """
            UPDATE students SET student_id=?, name=?, email=?, phone=?, gender=?
            WHERE id=?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setStudentParams(ps, s);
            ps.setInt(6, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM students WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM students")) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    private void setStudentParams(PreparedStatement ps, Student s) throws SQLException {
        ps.setString(1, s.getStudentId());
        ps.setString(2, s.getName());
        ps.setString(3, s.getEmail());
        ps.setString(4, s.getPhone());
        ps.setString(5, s.getGender());
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        String cat = rs.getString("created_at");
        LocalDateTime createdAt = LocalDateTime.now();
        if (cat != null && !cat.isBlank()) {
            try {
                String isoStr = cat.trim().replace(" ", "T");
                createdAt = LocalDateTime.parse(isoStr);
            } catch (Exception ignored) {
                createdAt = LocalDateTime.now();
            }
        }
        return new Student(
            rs.getInt("id"),
            rs.getString("student_id"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("gender"),
            createdAt
        );
    }
}
