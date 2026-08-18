package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents an exam result linking a student to a subject with marks and grade.
 * Serializable for RMI transport.
 */
public class ExamResult implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private int subjectId;
    private double marks;
    private double totalMarks;
    private String grade;
    private String academicYear;
    private int semester;
    private LocalDateTime createdAt;

    // Transient fields for display (populated by JOIN queries)
    private String studentName;
    private String studentCode;
    private String subjectName;
    private String subjectCode;

    public ExamResult() {}

    public ExamResult(int id, int studentId, int subjectId, double marks, double totalMarks,
                      String grade, String academicYear, int semester, LocalDateTime createdAt) {
        this.id = id;
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.marks = marks;
        this.totalMarks = totalMarks;
        this.grade = grade;
        this.academicYear = academicYear;
        this.semester = semester;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }

    public double getMarks() { return marks; }
    public void setMarks(double marks) { this.marks = marks; }

    public double getTotalMarks() { return totalMarks; }
    public void setTotalMarks(double totalMarks) { this.totalMarks = totalMarks; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    /**
     * Returns pass/fail status based on marks >= 50.
     */
    public String getStatus() {
        return marks >= 50.0 ? "PASS" : "FAIL";
    }

    /**
     * Returns percentage marks.
     */
    public double getPercentage() {
        if (totalMarks == 0) return 0;
        return (marks / totalMarks) * 100;
    }

    @Override
    public String toString() {
        return "ExamResult{id=" + id + ", studentId=" + studentId +
               ", subjectId=" + subjectId + ", marks=" + marks + ", grade='" + grade + "'}";
    }
}
