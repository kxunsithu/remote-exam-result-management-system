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
    // Academic Year Management
    // =========================================================================

    /**
     * Returns all academic years ordered by name.
     */
    List<AcademicYear> getAllAcademicYears() throws RemoteException;

    /**
     * Returns an academic year by its primary key.
     */
    AcademicYear getAcademicYearById(int id) throws RemoteException;

    /**
     * Adds a new academic year.
     * @return true on success
     * @throws RemoteException if the year name already exists or is invalid
     */
    boolean addAcademicYear(AcademicYear year) throws RemoteException;

    /**
     * Updates an existing academic year name.
     * @return true on success
     */
    boolean updateAcademicYear(AcademicYear year) throws RemoteException;

    /**
     * Deletes an academic year and its semesters, subjects and results.
     * @return true on success
     */
    boolean deleteAcademicYear(int id) throws RemoteException;

    // =========================================================================
    // Semester Management
    // =========================================================================

    /**
     * Returns all semesters (with their academic year names).
     */
    List<Semester> getAllSemesters() throws RemoteException;

    /**
     * Returns the semesters of a specific academic year.
     */
    List<Semester> getSemestersByAcademicYear(int academicYearId) throws RemoteException;

    /**
     * Returns a semester by its primary key.
     */
    Semester getSemesterById(int id) throws RemoteException;

    /**
     * Adds a new semester to an academic year.
     * @return true on success
     * @throws RemoteException if the semester number already exists in that year
     */
    boolean addSemester(Semester semester) throws RemoteException;

    /**
     * Updates an existing semester.
     * @return true on success
     */
    boolean updateSemester(Semester semester) throws RemoteException;

    /**
     * Deletes a semester and its subjects/results.
     * @return true on success
     */
    boolean deleteSemester(int id) throws RemoteException;

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
     * Returns all subjects that belong to a specific semester.
     */
    List<Subject> getSubjectsBySemester(int semesterId) throws RemoteException;

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

    /**
     * Returns all subjects that are not yet assigned to any semester.
     * Subjects are created standalone first, then attached to a semester
     * of an academic year from the academic year page.
     */
    List<Subject> getUnassignedSubjects() throws RemoteException;

    /**
     * Assigns existing subjects to a semester.
     * @param semesterId target semester primary key
     * @param subjectIds primary keys of subjects to attach
     * @return number of subjects newly assigned
     * @throws RemoteException if the semester does not exist, a subject is
     *         already assigned to another semester, or a subject code
     *         duplicates one already used in that semester
     */
    int assignSubjectsToSemester(int semesterId, int[] subjectIds) throws RemoteException;

    /**
     * Removes a subject from its semester (returns it to the unassigned pool).
     * @return true on success
     */
    boolean detachSubjectFromSemester(int subjectId) throws RemoteException;

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
     * Semester/academic-year filters match the subject's semester.
     */
    List<ExamResult> searchResults(String studentId, String subjectId,
                                   String semesterId, String academicYearId) throws RemoteException;

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
     * Uses the UCS(Hpa-an) grading scale.
     */
    String calculateOverallGrade(double averagePercentage) throws RemoteException;

    /**
     * Calculates the credit-weighted CGPA for a list of results.
     * Uses the UCS(Hpa-an) 4-point grading scale.
     * Formula: Σ(grade_score × credit_units) / Σ(credit_units)
     *
     * @param results list of exam results with subject credit data populated
     * @return CGPA value (0.0–4.0), or 0.0 if the list is empty
     */
    double calculateCGPA(List<ExamResult> results) throws RemoteException;

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
