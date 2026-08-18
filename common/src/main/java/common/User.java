package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents a system user (admin or student).
 * Serializable for potential RMI transport.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String email;
    private String password;
    private String role; // "ADMIN" or "STUDENT"
    private LocalDateTime createdAt;

    public User() {}

    public User(int id, String email, String password, String role, LocalDateTime createdAt) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{id=" + id + ", email='" + email + "', role='" + role + "'}";
    }
}
