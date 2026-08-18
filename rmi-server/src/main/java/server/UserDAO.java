package server;

import common.User;

import java.sql.*;
import java.time.LocalDateTime;

/**
 * Data Access Object for User operations.
 */
public class UserDAO {

    /**
     * Finds a user by email and role. Returns null if not found.
     */
    public User findByEmailAndRole(String email, String role) {
        String sql = "SELECT id, email, password, role, created_at FROM users WHERE email = ? AND role = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.findByEmailAndRole error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Finds a user by email only (any role).
     */
    public User findByEmail(String email) {
        String sql = "SELECT id, email, password, role, created_at FROM users WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.findByEmail error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Inserts a new user. Returns the generated ID, or -1 on failure.
     */
    public int insert(String email, String hashedPassword, String role) {
        String sql = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            ps.setString(3, role);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("UserDAO.insert error: " + e.getMessage());
        }
        return -1;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("email"),
            rs.getString("password"),
            rs.getString("role"),
            LocalDateTime.parse(rs.getString("created_at").replace(" ", "T"))
        );
    }
}
