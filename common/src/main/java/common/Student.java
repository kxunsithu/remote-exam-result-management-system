package common;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents a student in the university system.
 * Serializable for RMI transport.
 */
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String studentId;
    private String name;
    private String email;
    private String phone;
    private String gender;
    private LocalDate dateOfBirth;
    private String department;
    private int year;
    private LocalDateTime createdAt;

    public Student() {}

    public Student(int id, String studentId, String name, String email,
                   String phone, String gender, LocalDate dateOfBirth,
                   String department, int year, LocalDateTime createdAt) {
        this.id = id;
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.department = department;
        this.year = year;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Student{id=" + id + ", studentId='" + studentId + "', name='" + name + "'}";
    }
}
