package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents a university subject/course.
 * Subjects are created standalone (without year/semester) and can later be
 * attached to a semester of an academic year from the academic year page.
 * Serializable for RMI transport.
 */
public class Subject implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String subjectCode;
    private String subjectName;
    private int credit;
    private String department;
    private int semesterId;       // FK -> semesters.id; 0 = not yet assigned to any semester
    private LocalDateTime createdAt;

    // Transient fields for display (populated by JOIN queries)
    private Integer academicYearId;
    private String  academicYearName;
    private Integer semesterNumber;

    public Subject() {}

    public Subject(int id, String subjectCode, String subjectName, int credit,
                   String department, int semesterId, LocalDateTime createdAt) {
        this.id = id;
        this.subjectCode = subjectCode;
        this.subjectName = subjectName;
        this.credit = credit;
        this.department = department;
        this.semesterId = semesterId;
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

    public int getSemesterId() { return semesterId; }
    public void setSemesterId(int semesterId) { this.semesterId = semesterId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Integer getAcademicYearId() { return academicYearId; }
    public void setAcademicYearId(Integer academicYearId) { this.academicYearId = academicYearId; }

    public String getAcademicYearName() { return academicYearName; }
    public void setAcademicYearName(String academicYearName) { this.academicYearName = academicYearName; }

    public Integer getSemesterNumber() { return semesterNumber; }
    public void setSemesterNumber(Integer semesterNumber) { this.semesterNumber = semesterNumber; }

    @Override
    public String toString() {
        return "Subject{id=" + id + ", code='" + subjectCode + "', name='" + subjectName +
               "', semesterId=" + semesterId + "}";
    }
}
