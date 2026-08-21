package common;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * Represents an academic year (e.g. "2024-2025").
 * Serializable for RMI transport.
 */
public class AcademicYear implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String yearName;
    private LocalDateTime createdAt;

    // Transient fields for display (populated by JOIN/COUNT queries)
    private int semesterCount;
    private int subjectCount;

    public AcademicYear() {}

    public AcademicYear(int id, String yearName, LocalDateTime createdAt) {
        this.id = id;
        this.yearName = yearName;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getYearName() { return yearName; }
    public void setYearName(String yearName) { this.yearName = yearName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public int getSemesterCount() { return semesterCount; }
    public void setSemesterCount(int semesterCount) { this.semesterCount = semesterCount; }

    public int getSubjectCount() { return subjectCount; }
    public void setSubjectCount(int subjectCount) { this.subjectCount = subjectCount; }

    @Override
    public String toString() {
        return "AcademicYear{id=" + id + ", yearName='" + yearName + "'}";
    }
}
