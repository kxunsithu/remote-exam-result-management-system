package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents a semester belonging to a specific academic year.
 * Serializable for RMI transport.
 */
public class Semester implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int academicYearId;
    private int semesterNumber;   // 1..8
    private LocalDateTime createdAt;

    // Transient fields for display (populated by JOIN queries)
    private String academicYearName;
    private int subjectCount;

    public Semester() {}

    public Semester(int id, int academicYearId, int semesterNumber, LocalDateTime createdAt) {
        this.id = id;
        this.academicYearId = academicYearId;
        this.semesterNumber = semesterNumber;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAcademicYearId() { return academicYearId; }
    public void setAcademicYearId(int academicYearId) { this.academicYearId = academicYearId; }

    public int getSemesterNumber() { return semesterNumber; }
    public void setSemesterNumber(int semesterNumber) { this.semesterNumber = semesterNumber; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getAcademicYearName() { return academicYearName; }
    public void setAcademicYearName(String academicYearName) { this.academicYearName = academicYearName; }

    public int getSubjectCount() { return subjectCount; }
    public void setSubjectCount(int subjectCount) { this.subjectCount = subjectCount; }

    @Override
    public String toString() {
        return "Semester{id=" + id + ", academicYearId=" + academicYearId +
               ", semesterNumber=" + semesterNumber + "}";
    }
}
