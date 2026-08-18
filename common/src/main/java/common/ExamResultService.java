package common;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

/**
 * Remote interface for the Exam Result Management Service.
 * All methods throw RemoteException as required by Java RMI.
 *
 * <p>This interface is the contract between the web application (RMI client)
 * and the RMI server (business logic layer).</p>
 */
public interface ExamResultService extends Remote {

    // =========================================================================
    // Authentication
    // =========================================================================

    /**
     * Authenticates a user by email, password, and role.
     * @param email    the user's email address
     * @param password the plain-text password to verify
     * @param role     expected role ("ADMIN" or "STUDENT")
     * @return the authenticated User object, or null if credentials are invalid
     */
    User login(String email, String password, String role) throws RemoteException;

    /**
     * Registers a new student account.
     * @param email    new student email
     * @param password plain-text password (will be hashed by server)
     * @return true if registration succeeded, false if email already exists
     */
    boolean registerStudent(String email, String password) throws RemoteException;

    // =========================================================================
    // Student Management
    // =========================================================================

    /**
     * Returns all students in the system.
     */
    List<Student> getAllStudents() throws RemoteException;

    /**
     * Returns students matching the search keyword (name, ID, email, department).
     */
    List<Student> searchStudents(String keyword) throws RemoteException;

    /**
     * Returns a student by their primary key.
     */
    Student getStudentById(int id) throws RemoteException;

    /**
     * Returns a student by their email address (used for session binding).
     */
    Student getStudentByEmail(String email) throws RemoteException;

    /**
     * Adds a new student to the database.
     * @return true on success
     * @throws RemoteException if studentId or email already exists
     */
    boolean addStudent(Student student) throws RemoteException;

    /**
     * Updates an existing student record.
     * @return true on success
     */
    boolean updateStudent(Student student) throws RemoteException;

    /**
     * Deletes a student and their associated exam results.
     * @return true on success
     */
    boolean deleteStudent(int id) throws RemoteException;

    // =========================================================================
    // Subject Management
    // =========================================================================

    /**
     * Returns all subjects.
     */
    List<Subject> getAllSubjects() throws RemoteException;

    /**
     * Returns subjects matching the search keyword.
     */
    List<Subject> searchSubjects(String keyword) throws RemoteException;

    /**
     * Returns a subject by its primary key.
     */
    Subject getSubjectById(int id) throws RemoteException;

    /**
     * Adds a new subject.
     * @return true on success
     * @throws RemoteException if subject code already exists
     */
    boolean addSubject(Subject subject) throws RemoteException;

    /**
     * Updates an existing subject.
     * @return true on success
     */
    boolean updateSubject(Subject subject) throws RemoteException;

    /**
     * Deletes a subject and its associated exam results.
     * @return true on success
     */
    boolean deleteSubject(int id) throws RemoteException;

    // =========================================================================
    // Exam Result Management
    // =========================================================================

    /**
     * Returns all exam results with student and subject details.
     */
    List<ExamResult> getAllResults() throws RemoteException;

    /**
     * Returns exam results filtered by optional criteria.
     * Pass null or empty string to ignore a filter.
     */
    List<ExamResult> searchResults(String studentId, String subjectId,
                                   String semester, String academicYear) throws RemoteException;

    /**
     * Returns an exam result by its primary key.
     */
    ExamResult getResultById(int id) throws RemoteException;

    /**
     * Returns all exam results for a specific student (by DB primary key).
     * Used to enforce that students can only see their own results.
     */
    List<ExamResult> getStudentResults(int studentDbId) throws RemoteException;

    /**
     * Adds an exam result. The server calculates and assigns the grade.
     * @return true on success
     */
    boolean addExamResult(ExamResult result) throws RemoteException;

    /**
     * Updates an existing exam result. The server recalculates the grade.
     * @return true on success
     */
    boolean updateExamResult(ExamResult result) throws RemoteException;

    /**
     * Deletes an exam result.
     * @return true on success
     */
    boolean deleteExamResult(int id) throws RemoteException;

    // =========================================================================
    // Analytics
    // =========================================================================

    /**
     * Calculates the average marks percentage for a list of results.
     */
    double calculateAverage(List<ExamResult> results) throws RemoteException;

    /**
     * Calculates the overall grade based on average percentage.
     * Uses the standard university grading scale.
     */
    String calculateOverallGrade(double averagePercentage) throws RemoteException;

    // =========================================================================
    // Dashboard Statistics
    // =========================================================================

    /** Returns total count of students. */
    int getTotalStudents() throws RemoteException;

    /** Returns total count of subjects. */
    int getTotalSubjects() throws RemoteException;

    /** Returns total count of exam results. */
    int getTotalResults() throws RemoteException;

    /** Returns the most recent N exam results for the admin dashboard. */
    List<ExamResult> getRecentResults(int limit) throws RemoteException;
}
