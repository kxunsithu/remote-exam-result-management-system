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
    public Subject getSubjectById(int id) throws RemoteException {
        return subjectDAO.findById(id);
    }

    @Override
    public boolean addSubject(Subject subject) throws RemoteException {
        if (subject == null) return false;
        validateSubject(subject);
        return subjectDAO.insert(subject);
    }

    @Override
    public boolean updateSubject(Subject subject) throws RemoteException {
        if (subject == null || subject.getId() <= 0) return false;
        validateSubject(subject);
        return subjectDAO.update(subject);
    }

    @Override
    public boolean deleteSubject(int id) throws RemoteException {
        return subjectDAO.delete(id);
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
        String existingYear = resultDAO.getAcademicYearForStudentSemester(
                result.getStudentId(), result.getSemester(), result.getExamType(), 0);
        if (existingYear != null && !existingYear.equalsIgnoreCase(result.getAcademicYear().trim())) {
            throw new RemoteException("ဤကျောင်းသားအတွက် Semester " + result.getSemester() +
                    " (" + result.getExamType() + ") ကို ပညာသင်နှစ် (" + existingYear + ") တွင် ထည့်သွင်းထားပြီးဖြစ်ပါသဖြင့် တခြားပညာသင်နှစ်တွင် ပြန်လည်သုံး၍ မရပါ။");
        }
        if (resultDAO.existsDuplicate(result.getStudentId(), result.getSubjectId(),
                result.getAcademicYear(), result.getSemester(), result.getExamType(), 0)) {
            throw new RemoteException("ဤကျောင်းသားအတွက် ယခုဘာသာရပ်၊ ပညာသင်နှစ်၊ Semester နှင့် Exam Type (" + result.getExamType() + ") ရလဒ် ထည့်သွင်းပြီးဖြစ်ပါသည်။");
        }
        // Server calculates grade
        result.setGrade(computeGrade(result.getMarks(), result.getTotalMarks()));
        return resultDAO.insert(result);
    }

    @Override
    public boolean updateExamResult(ExamResult result) throws RemoteException {
        if (result == null || result.getId() <= 0) return false;
        validateResult(result);
        String existingYear = resultDAO.getAcademicYearForStudentSemester(
                result.getStudentId(), result.getSemester(), result.getExamType(), result.getId());
        if (existingYear != null && !existingYear.equalsIgnoreCase(result.getAcademicYear().trim())) {
            throw new RemoteException("ဤကျောင်းသားအတွက် Semester " + result.getSemester() +
                    " (" + result.getExamType() + ") ကို ပညာသင်နှစ် (" + existingYear + ") တွင် ထည့်သွင်းထားပြီးဖြစ်ပါသဖြင့် တခြားပညာသင်နှစ်တွင် ပြန်လည်သုံး၍ မရပါ။");
        }
        if (resultDAO.existsDuplicate(result.getStudentId(), result.getSubjectId(),
                result.getAcademicYear(), result.getSemester(), result.getExamType(), result.getId())) {
            throw new RemoteException("ဤကျောင်းသားအတွက် ယခုဘာသာရပ်၊ ပညာသင်နှစ်၊ Semester နှင့် Exam Type (" + result.getExamType() + ") ရလဒ် ထည့်သွင်းပြီးဖြစ်ပါသည်။");
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

    private void validateSubject(Subject s) throws RemoteException {
        if (s.getSubjectCode() == null || s.getSubjectCode().isBlank())
            throw new RemoteException("Subject code is required.");
        if (s.getSubjectName() == null || s.getSubjectName().isBlank())
            throw new RemoteException("Subject name is required.");
        if (s.getCredit() < 1 || s.getCredit() > 6)
            throw new RemoteException("Credit must be between 1 and 6.");
        if (s.getDepartment() == null || s.getDepartment().isBlank())
            throw new RemoteException("Department is required.");
        if (s.getSemester() < 1 || s.getSemester() > 8)
            throw new RemoteException("Semester must be between 1 and 8.");
    }

    private void validateResult(ExamResult r) throws RemoteException {
        if (r.getMarks() < 0)
            throw new RemoteException("Marks cannot be negative.");
        if (r.getTotalMarks() <= 0)
            throw new RemoteException("Total marks must be positive.");
        if (r.getMarks() > r.getTotalMarks())
            throw new RemoteException("Marks cannot exceed total marks.");
        if (r.getAcademicYear() == null || r.getAcademicYear().isBlank())
            throw new RemoteException("Academic year is required.");
        if (r.getSemester() < 1 || r.getSemester() > 8)
            throw new RemoteException("Semester must be between 1 and 8.");
    }
}
