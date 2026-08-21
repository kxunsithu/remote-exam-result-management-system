package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents an exam result linking a student to a subject with marks and grade.
 * The academic year and semester are derived from the subject
 * (subject -> semester -> academic year) and populated as display fields.
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
    private String examType = "REGULAR";
    private LocalDateTime createdAt;

    // Transient display fields (populated by JOIN queries)
    private int    academicYearId;
    private String academicYear;
    private int    semesterId;     // semesters.id the subject belongs to
    private int    semester;
    private String studentName;
    private String studentCode;
    private String subjectName;
    private String subjectCode;
    private int    subjectCredit;  // credit hours of the subject (from subjects JOIN)

    public ExamResult() {}

    public ExamResult(int id, int studentId, int subjectId, double marks, double totalMarks,
                      String grade, String examType, LocalDateTime createdAt) {
        this.id = id;
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.marks = marks;
        this.totalMarks = totalMarks;
        this.grade = grade;
        this.examType = (examType != null && !examType.isBlank()) ? examType : "REGULAR";
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

    public String getExamType() { return examType != null ? examType : "REGULAR"; }
    public void setExamType(String examType) { this.examType = examType; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public int getAcademicYearId() { return academicYearId; }
    public void setAcademicYearId(int academicYearId) { this.academicYearId = academicYearId; }

    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public int getSemesterId() { return semesterId; }
    public void setSemesterId(int semesterId) { this.semesterId = semesterId; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public int getSubjectCredit() { return subjectCredit; }
    public void setSubjectCredit(int subjectCredit) { this.subjectCredit = subjectCredit; }


    /**
     * Returns pass/fail status. Pass threshold is 50% (C grade or better).
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

    /**
     * Maps a letter grade to its grade score on the UCS(Hpa-an) 4-point scale.
     * A+=4.0, A=4.0, A-=3.67, B+=3.33, B=3.0, B-=2.67,
     * C+=2.33, C=2.0, D=1.0, F=0.0
     */
    public static double gradeToPoints(String grade) {
        if (grade == null) return 0.0;
        return switch (grade.trim()) {
            case "A+" -> 4.0;
            case "A"  -> 4.0;
            case "A-" -> 3.67;
            case "B+" -> 3.33;
            case "B"  -> 3.0;
            case "B-" -> 2.67;
            case "C+" -> 2.33;
            case "C"  -> 2.0;
            case "D"  -> 1.0;
            default   -> 0.0;  // F, Abs, I
        };
    }


    @Override
    public String toString() {
        return "ExamResult{id=" + id + ", studentId=" + studentId +
               ", subjectId=" + subjectId + ", marks=" + marks + ", grade='" + grade + "'}";
    }
}
