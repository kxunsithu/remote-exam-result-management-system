package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents a university subject/course.
 * Serializable for RMI transport.
 */
public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String subjectCode;
    private String subjectName;
    private int credit;
    private String department;
    private int semester;
    private LocalDateTime createdAt;

    public Subject() {}

    public Subject(int id, String subjectCode, String subjectName, int credit,
                   String department, int semester, LocalDateTime createdAt) {
        this.id = id;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credit = credit;
        this.department = department;
        this.semester = semester;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getCredit() { return credit; }
    public void setCredit(int credit) { this.credit = credit; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Subject{id=" + id + ", code='" + subjectCode + "', name='" + subjectName + "'}";
    }
}
