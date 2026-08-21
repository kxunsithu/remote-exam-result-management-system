package server;

import org.mindrot.jbcrypt.BCrypt;
import common.*;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

/**
 * Implementation of the ExamResultService remote interface.
 *
 * <p>This class runs on the RMI Server and handles all business logic,
 * including grade calculation, password hashing, and data validation.
 * It delegates database operations to the respective DAO classes.</p>
 */
public class ExamResultServiceImpl extends UnicastRemoteObject implements ExamResultService {

    private static final long serialVersionUID = 1L;

    private final UserDAO    userDAO    = new UserDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final ExamResultDAO resultDAO  = new ExamResultDAO();
    private final AcademicYearDAO academicYearDAO = new AcademicYearDAO();
    private final SemesterDAO     semesterDAO     = new SemesterDAO();

    public ExamResultServiceImpl() throws RemoteException {
        super();
    }

    // =========================================================================
    // Authentication
    // =========================================================================

    @Override
    public User login(String email, String password, String role) throws RemoteException {
        if (email == null || password == null || role == null) return null;
        User user = userDAO.findByEmailAndRole(email.trim(), role.trim().toUpperCase());
        if (user == null) return null;

        if (!BCrypt.checkpw(password, user.getPassword())) return null;

        // Clear password before returning
        user.setPassword(null);
        return user;
    }

    @Override
    public boolean registerStudent(String email, String password) throws RemoteException {
        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            return false;
        }
        // Check if email already exists
        if (userDAO.findByEmail(email.trim()) != null) {
            return false;
        }
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
        return userDAO.insert(email.trim().toLowerCase(), hashed, "STUDENT") > 0;
    }

    // =========================================================================
    // Student Management
    // =========================================================================

    @Override
    public List<Student> getAllStudents() throws RemoteException {
        return studentDAO.findAll();
    }

    @Override
    public List<Student> searchStudents(String keyword) throws RemoteException {
        if (keyword == null || keyword.isBlank()) return studentDAO.findAll();
        return studentDAO.search(keyword.trim());
    }

    @Override
    public Student getStudentById(int id) throws RemoteException {
        return studentDAO.findById(id);
    }

    @Override
    public Student getStudentByEmail(String email) throws RemoteException {
        if (email == null) return null;
        return studentDAO.findByEmail(email.trim());
    }

    @Override
    public boolean addStudent(Student student) throws RemoteException {
        if (student == null) return false;
        validateStudent(student);
        return studentDAO.insert(student);
    }

    @Override
    public boolean updateStudent(Student student) throws RemoteException {
        if (student == null || student.getId() <= 0) return false;
        validateStudent(student);
        return studentDAO.update(student);
    }

    @Override
    public boolean deleteStudent(int id) throws RemoteException {
        return studentDAO.delete(id);
    }

    // =========================================================================
    // Academic Year Management
    // =========================================================================

    @Override
    public List<AcademicYear> getAllAcademicYears() throws RemoteException {
        return academicYearDAO.findAll();
    }

    @Override
    public AcademicYear getAcademicYearById(int id) throws RemoteException {
        return academicYearDAO.findById(id);
    }

    @Override
    public boolean addAcademicYear(AcademicYear year) throws RemoteException {
        if (year == null) return false;
        validateAcademicYear(year);
        if (academicYearDAO.findByName(year.getYearName()) != null) {
            throw new RemoteException("ပညာသင်နှစ် (" + year.getYearName().trim() + ") ရှိပြီးသား ဖြစ်နေပါသည်။");
        }
        return academicYearDAO.insert(year);
    }

    @Override
    public boolean updateAcademicYear(AcademicYear year) throws RemoteException {
        if (year == null || year.getId() <= 0) return false;
        validateAcademicYear(year);
        AcademicYear existing = academicYearDAO.findByName(year.getYearName());
        if (existing != null && existing.getId() != year.getId()) {
            throw new RemoteException("ပညာသင်နှစ် (" + year.getYearName().trim() + ") ရှိပြီးသား ဖြစ်နေပါသည်။");
        }
        return academicYearDAO.update(year);
    }

    @Override
    public boolean deleteAcademicYear(int id) throws RemoteException {
        return academicYearDAO.delete(id);
    }

    // =========================================================================
    // Semester Management
    // =========================================================================

    @Override
    public List<Semester> getAllSemesters() throws RemoteException {
        return semesterDAO.findAll();
    }

    @Override
    public List<Semester> getSemestersByAcademicYear(int academicYearId) throws RemoteException {
        return semesterDAO.findByAcademicYear(academicYearId);
    }

    @Override
    public Semester getSemesterById(int id) throws RemoteException {
        return semesterDAO.findById(id);
    }

    @Override
    public boolean addSemester(Semester semester) throws RemoteException {
        if (semester == null) return false;
        validateSemester(semester);
        if (academicYearDAO.findById(semester.getAcademicYearId()) == null) {
            throw new RemoteException("ရွေးချယ်ထားသော ပညာသင်နှစ်ကို ရှာမတွေ့ပါ။");
        }
        if (semesterDAO.findUnique(semester.getAcademicYearId(), semester.getSemesterNumber()) != null) {
            throw new RemoteException("ယခုပညာသင်နှစ်တွင် Semester " + semester.getSemesterNumber() +
                    " ကို ထည့်သွင်းပြီးသား ဖြစ်နေပါသည်။");
        }
        return semesterDAO.insert(semester);
    }

    @Override
    public boolean updateSemester(Semester semester) throws RemoteException {
        if (semester == null || semester.getId() <= 0) return false;
        validateSemester(semester);
        if (academicYearDAO.findById(semester.getAcademicYearId()) == null) {
            throw new RemoteException("ရွေးချယ်ထားသော ပညာသင်နှစ်ကို ရှာမတွေ့ပါ။");
        }
        Semester existing = semesterDAO.findUnique(semester.getAcademicYearId(), semester.getSemesterNumber());
        if (existing != null && existing.getId() != semester.getId()) {
            throw new RemoteException("ယခုပညာသင်နှစ်တွင် Semester " + semester.getSemesterNumber() +
                    " ကို ထည့်သွင်းပြီးသား ဖြစ်နေပါသည်။");
        }
        return semesterDAO.update(semester);
    }

    @Override
    public boolean deleteSemester(int id) throws RemoteException {
        return semesterDAO.delete(id);
    }

    // =========================================================================
    // Subject Management
    // =========================================================================

    @Override
    public List<Subject> getAllSubjects() throws RemoteException {
        return subjectDAO.findAll();
    }

    @Override
    public List<Subject> searchSubjects(String keyword) throws RemoteException {
        if (keyword == null || keyword.isBlank()) return subjectDAO.findAll();
        return subjectDAO.search(keyword.trim());
    }

    @Override
    public List<Subject> getSubjectsBySemester(int semesterId) throws RemoteException {
        return subjectDAO.findBySemester(semesterId);
    }

    @Override
    public Subject getSubjectById(int id) throws RemoteException {
        return subjectDAO.findById(id);
    }

    @Override
    public boolean addSubject(Subject subject) throws RemoteException {
        if (subject == null) return false;
        validateSubject(subject);
        ensureSubjectCodeAvailable(subject.getSubjectCode(), subject.getSemesterId(), 0);
        return subjectDAO.insert(subject);
    }

    @Override
    public boolean updateSubject(Subject subject) throws RemoteException {
        if (subject == null || subject.getId() <= 0) return false;
        validateSubject(subject);
        ensureSubjectCodeAvailable(subject.getSubjectCode(), subject.getSemesterId(), subject.getId());
        return subjectDAO.update(subject);
    }

    @Override
    public boolean deleteSubject(int id) throws RemoteException {
        return subjectDAO.delete(id);
    }

    @Override
    public List<Subject> getUnassignedSubjects() throws RemoteException {
        return subjectDAO.findUnassigned();
    }

    @Override
    public int assignSubjectsToSemester(int semesterId, int[] subjectIds) throws RemoteException {
        if (subjectIds == null || subjectIds.length == 0) return 0;
        Semester target = semesterDAO.findById(semesterId);
        if (target == null)
            throw new RemoteException("ရွေးချယ်ထားသော Semester ကို ရှာမတွေ့ပါ။");
        int targetYearId = target.getAcademicYearId();

        int assigned = 0;
        for (int subjectId : subjectIds) {
            Subject subject = subjectDAO.findById(subjectId);
            if (subject == null)
                throw new RemoteException("ဘာသာရပ် #" + subjectId + " ကို ရှာမတွေ့ပါ။");
            if (subject.getSemesterId() == semesterId) continue; // already in this semester
            ensureSubjectCodeAvailable(subject.getSubjectCode(), semesterId, subjectId);
            if (subject.getSemesterId() > 0) {
                // Already assigned in another semester — allowed only across
                // different academic years (a copy is created for the new year).
                if (subject.getAcademicYearId() != null && subject.getAcademicYearId() == targetYearId)
                    throw new RemoteException("ဘာသာရပ် (" + subject.getSubjectName() +
                            ") သည် ဤပညာသင်နှစ်၏ အခြား Semester တစ်ခုတွင် ရှိနေပြီး ဖြစ်ပါသည်။");
                Subject copy = new Subject();
                copy.setSubjectCode(subject.getSubjectCode());
                copy.setSubjectName(subject.getSubjectName());
                copy.setCredit(subject.getCredit());
                copy.setDepartment(subject.getDepartment());
                copy.setSemesterId(semesterId);
                if (subjectDAO.insert(copy)) assigned++;
            } else {
                if (subjectDAO.assignToSemester(subjectId, semesterId)) assigned++;
            }
        }
        return assigned;
    }

    @Override
    public boolean detachSubjectFromSemester(int subjectId) throws RemoteException {
        Subject subject = subjectDAO.findById(subjectId);
        if (subject == null) return false;
        return subjectDAO.detachFromSemester(subjectId);
    }

    /**
     * Ensures the subject code is not duplicated within its scope:
     * among subjects not yet assigned to any semester, or — when attaching
     * to a semester — anywhere within that semester's academic year.
     * The same code is allowed in different academic years.
     */
    private void ensureSubjectCodeAvailable(String code, int semesterId, int excludeId) throws RemoteException {
        boolean exists;
        if (semesterId > 0) {
            Semester sem = semesterDAO.findById(semesterId);
            int yearId = sem != null ? sem.getAcademicYearId() : 0;
            exists = subjectDAO.codeExistsInAcademicYear(code, yearId, excludeId);
        } else {
            exists = subjectDAO.codeExistsWithoutSemester(code, excludeId);
        }
        if (exists)
            throw new RemoteException(semesterId > 0
                    ? "ဘာသာရပ်သင်္ကေတ (" + code.trim() + ") သည် ဤပညာသင်နှစ်တွင် ရှိပြီးသား ဖြစ်နေပါသည်။"
                    : "ဘာသာရပ်သင်္ကေတ (" + code.trim() + ") ရှိပြီးသား ဖြစ်နေပါသည်။");
    }

    // =========================================================================
    // Exam Result Management
    // =========================================================================

    @Override
    public List<ExamResult> getAllResults() throws RemoteException {
        return resultDAO.findAll();
    }

    @Override
    public List<ExamResult> searchResults(String studentId, String subjectId,
                                           String semester, String academicYear) throws RemoteException {
        return resultDAO.search(studentId, subjectId, semester, academicYear);
    }

    @Override
    public ExamResult getResultById(int id) throws RemoteException {
        return resultDAO.findById(id);
    }

    @Override
    public List<ExamResult> getStudentResults(int studentDbId) throws RemoteException {
        return resultDAO.findByStudentDbId(studentDbId);
    }

    @Override
    public boolean addExamResult(ExamResult result) throws RemoteException {
        if (result == null) return false;
        validateResult(result);
        if (resultDAO.existsDuplicate(result.getStudentId(), result.getSubjectId(),
                result.getExamType(), 0)) {
            throw new RemoteException("ဤကျောင်းသားအတွက် ယခုဘာသာရပ် (" +
                    subjectDisplayName(result.getSubjectId()) + ") ၏ " + result.getExamType() +
                    " ရလဒ် ထည့်သွင်းပြီးဖြစ်ပါသည်။");
        }
        // Server calculates grade
        result.setGrade(computeGrade(result.getMarks(), result.getTotalMarks()));
        return resultDAO.insert(result);
    }

    @Override
    public boolean updateExamResult(ExamResult result) throws RemoteException {
        if (result == null || result.getId() <= 0) return false;
        validateResult(result);
        if (resultDAO.existsDuplicate(result.getStudentId(), result.getSubjectId(),
                result.getExamType(), result.getId())) {
            throw new RemoteException("ဤကျောင်းသားအတွက် ယခုဘာသာရပ် (" +
                    subjectDisplayName(result.getSubjectId()) + ") ၏ " + result.getExamType() +
                    " ရလဒ် ထည့်သွင်းပြီးဖြစ်ပါသည်။");
        }
        // Server recalculates grade
        result.setGrade(computeGrade(result.getMarks(), result.getTotalMarks()));
        return resultDAO.update(result);
    }

    @Override
    public boolean deleteExamResult(int id) throws RemoteException {
        return resultDAO.delete(id);
    }

    // =========================================================================
    // Analytics
    // =========================================================================

    @Override
    public double calculateAverage(List<ExamResult> results) throws RemoteException {
        if (results == null || results.isEmpty()) return 0.0;
        double totalObtained = results.stream().mapToDouble(ExamResult::getMarks).sum();
        double totalPossible = results.stream().mapToDouble(ExamResult::getTotalMarks).sum();
        if (totalPossible == 0) return 0.0;
        return Math.round((totalObtained / totalPossible) * 10000.0) / 100.0;
    }

    @Override
    public String calculateOverallGrade(double averagePercentage) throws RemoteException {
        return computeGrade(averagePercentage, 100.0);
    }
    @Override
    public double calculateCGPA(List<ExamResult> results) throws RemoteException {
        if (results == null || results.isEmpty()) return 0.0;
        double totalGradePoints = 0.0;
        int    totalCredits     = 0;
        for (ExamResult r : results) {
            int credit = r.getSubjectCredit();
            if (credit <= 0) continue;  // skip if credit info unavailable
            totalGradePoints += gradeToPoints(r.getGrade()) * credit;
            totalCredits     += credit;
        }
        if (totalCredits == 0) return 0.0;
        return Math.round((totalGradePoints / totalCredits) * 100.0) / 100.0;
    }

    // =========================================================================
    // Dashboard Statistics
    // =========================================================================

    @Override
    public int getTotalStudents() throws RemoteException {
        return studentDAO.count();
    }

    @Override
    public int getTotalSubjects() throws RemoteException {
        return subjectDAO.count();
    }

    @Override
    public int getTotalResults() throws RemoteException {
        return resultDAO.count();
    }

    @Override
    public List<ExamResult> getRecentResults(int limit) throws RemoteException {
        return resultDAO.findRecent(limit);
    }

    // =========================================================================
    // Internal helpers (also used by DatabaseInitializer)
    // =========================================================================

    /**
     * Computes grade based on percentage using the UCS(Hpa-an) official scale.
     *
     * Scale: A+(≥90), A(80-89), A-(75-79), B+(70-74), B(65-69),
     *        B-(60-64), C+(55-59), C(50-54), D(40-49), F(<40)
     */
    public static String computeGrade(double marks, double totalMarks) {
        if (totalMarks <= 0) return "F";
        double pct = (marks / totalMarks) * 100.0;
        if (pct >= 90) return "A+";
        if (pct >= 80) return "A";
        if (pct >= 75) return "A-";
        if (pct >= 70) return "B+";
        if (pct >= 65) return "B";
        if (pct >= 60) return "B-";
        if (pct >= 55) return "C+";
        if (pct >= 50) return "C";
        if (pct >= 40) return "D";
        return "F";
    }

    /**
     * Maps a letter grade to its grade score on the UCS(Hpa-an) 4-point scale.
     * Delegates to {@link common.ExamResult#gradeToPoints(String)} — single source of truth.
     */
    public static double gradeToPoints(String grade) {
        return ExamResult.gradeToPoints(grade);
    }


    // =========================================================================
    // Validation helpers
    // =========================================================================

    private void validateStudent(Student s) throws RemoteException {
        if (s.getStudentId() == null || s.getStudentId().isBlank())
            throw new RemoteException("Student ID is required.");
        if (s.getName() == null || s.getName().isBlank())
            throw new RemoteException("Student name is required.");
        if (s.getEmail() == null || s.getEmail().isBlank() || !s.getEmail().contains("@"))
            throw new RemoteException("Valid email is required.");
    }

    private void validateAcademicYear(AcademicYear y) throws RemoteException {
        if (y.getYearName() == null || y.getYearName().isBlank())
            throw new RemoteException("ပညာသင်နှစ် ထည့်သွင်းရန် လိုအပ်ပါသည်။ (e.g. 2024-2025)");
        if (!y.getYearName().trim().matches("\\d{4}\\s*-\\s*\\d{4}"))
            throw new RemoteException("ပညာသင်နှစ် ပုံစံမှားနေပါသည်။ ဥပမာ - 2024-2025");
    }

    private void validateSemester(Semester s) throws RemoteException {
        if (s.getAcademicYearId() <= 0)
            throw new RemoteException("ပညာသင်နှစ် ရွေးချယ်ရန် လိုအပ်ပါသည်။");
        if (s.getSemesterNumber() < 1 || s.getSemesterNumber() > 8)
            throw new RemoteException("Semester သည် 1 နှင့် 8 ကြားရှိရမည်။");
    }

    private void validateSubject(Subject s) throws RemoteException {
        if (s.getSubjectCode() == null || s.getSubjectCode().isBlank())
            throw new RemoteException("Subject code is required.");
        if (s.getSubjectName() == null || s.getSubjectName().isBlank())
            throw new RemoteException("Subject name is required.");
        if (s.getCredit() < 1 || s.getCredit() > 6)
            throw new RemoteException("Credit must be between 1 and 6.");
        if (s.getDepartment() == null || s.getDepartment().isBlank())
            throw new RemoteException("Department is required.");
        // Semester assignment is optional — subjects are created standalone
        // and attached to a semester later from the academic year page.
        if (s.getSemesterId() > 0 && semesterDAO.findById(s.getSemesterId()) == null)
            throw new RemoteException("ရွေးချယ်ထားသော Semester ကို ရှာမတွေ့ပါ။");
    }

    private void validateResult(ExamResult r) throws RemoteException {
        if (r.getMarks() < 0)
            throw new RemoteException("Marks cannot be negative.");
        if (r.getTotalMarks() <= 0)
            throw new RemoteException("Total marks must be positive.");
        if (r.getMarks() > r.getTotalMarks())
            throw new RemoteException("Marks cannot exceed total marks.");
        if (r.getStudentId() <= 0)
            throw new RemoteException("ကျောင်းသား ရွေးချယ်ရန် လိုအပ်ပါသည်။");
        if (r.getSubjectId() <= 0)
            throw new RemoteException("ဘာသာရပ် ရွေးချယ်ရန် လိုအပ်ပါသည်။");
        Subject subject = subjectDAO.findById(r.getSubjectId());
        if (subject == null)
            throw new RemoteException("ရွေးချယ်ထားသော ဘာသာရပ်ကို ရှာမတွေ့ပါ။");
        if (subject.getSemesterId() <= 0)
            throw new RemoteException("ဘာသာရပ် (" + subject.getSubjectName() +
                    ") ကို ပညာသင်နှစ်၏ Semester တွင် အရင်ထည့်သွင်းပါ။");
        // Derive academic year / semester from the subject for display consistency
        r.setAcademicYearId(subject.getAcademicYearId() != null ? subject.getAcademicYearId() : 0);
        r.setAcademicYear(subject.getAcademicYearName());
        r.setSemester(subject.getSemesterNumber() != null ? subject.getSemesterNumber() : 0);
    }

    private String subjectDisplayName(int subjectId) {
        Subject s = subjectDAO.findById(subjectId);
        return s != null ? s.getSubjectName() : ("#" + subjectId);
    }
}
