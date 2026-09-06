# Remote Exam Result Management System (RERMS)

**University of Computer Studies, Hpa-an (UCS Hpa-an)**
Final Year Project Documentation — Academic Year 2024–2025

---

## Table of Contents

| Chapter | Title | Page |
|:---|:---|:---:|
| **Chapter 1** | **Introduction** | **4** |
| 1.1 | Exam Result Management System | 4 |
| 1.2 | Objectives | 4 |
| 1.3 | System Development Environment | 4 |
| **Chapter 2** | **Remote Method Invocation (RMI)** | **6** |
| 2.1 | Remote Method Invocation (RMI) | 6 |
| 2.2 | Design Issues For RMI | 6 |
| 2.3 | Implementation of Remote Invocation Method (RMI) | 7 |
| **Chapter 3** | **Implementation** | **11** |
| **Chapter 4** | **Conclusion** | **17** |

---

## Chapter (1) Introduction

### 1.1 Exam Result Management System

The **Remote Exam Result Management System (RERMS)** is an enterprise-grade, distributed university management application developed for the University of Computer Studies, Hpa-an (UCS Hpa-an). The system is designed to manage student exam results securely and efficiently using a modern distributed architecture.

Traditional exam result management in universities relies on manual, paper-based records. These records are prone to human error, data loss, and inconsistent grade calculations. There is also no standardized way for students to view their personal academic records on demand, nor to generate official printable transcripts.

RERMS solves these problems by providing:

- A **centralized digital platform** where administrators can manage all student records, subjects, academic years, and exam results in one place.
- A **secure student self-service portal** that allows students to view their own results, CGPA, and print official academic transcripts at any time.
- An **automated server-side grading engine** that computes grades and CGPA consistently according to the official UCS Hpa-an 10-tier grading scale.
- A **Role-Based Access Control (RBAC)** system that strictly separates administrator and student capabilities.

The core technology that powers the communication between the web front-end and the database server is **Java Remote Method Invocation (Java RMI)**, demonstrating how distributed systems can be applied to solve real-world academic management challenges.

---

### 1.2 Objectives

The primary objectives of this project are as follows:

1. **Implement Java RMI as Distributed Middleware** — Use Java RMI (port 1099) as the communication protocol between the web application (client) and the business logic server, ensuring the web application never directly accesses the database.

2. **Enforce Role-Based Access Control (RBAC)** — Provide separate and secure portals for administrators and students, protected by a Jakarta Servlet `AuthFilter` that enforces session-based authentication.

3. **Build an Automated Grading Engine** — Implement a server-side grade calculation engine that converts raw marks into official UCS Hpa-an grades (A+ through F) and computes credit-weighted CGPA (on a 4.0 scale).

4. **Design a Normalized Relational Database** — Design and implement a normalized SQLite database with five tables: `users`, `students`, `academic_years`, `semesters`, `subjects`, and `exam_results`, enforcing referential integrity with foreign key constraints.

5. **Enable Full Admin CRUD Operations** — Allow administrators to create, read, update, and delete records for students, academic years, semesters, subjects, and exam results through an intuitive web interface.

6. **Deliver a Student Self-Service Portal** — Allow students to securely view their semester-wise results, CGPA, pass/fail status, and generate official A4-format academic transcripts with university header and registrar signature block.

7. **Implement Secure Password Management** — Store all passwords as BCrypt hashes (cost factor 12) to ensure no plain-text credentials are stored in the database.

---

### 1.3 System Development Environment

The system is built using the following development tools, frameworks, and technologies:

#### Hardware Environment

| Component | Specification |
|:---|:---|
| Processor | Intel Core i5 / AMD Ryzen 5 or higher |
| RAM | 8 GB or higher |
| Storage | 256 GB SSD or higher |
| Network | Local network (localhost for RMI) |

#### Software Environment

| Layer | Technology | Version |
|:---|:---|:---|
| **Programming Language** | Java | JDK 17 / 21 |
| **Build Tool** | Apache Maven | 3.8+ |
| **Web Framework** | Jakarta EE Servlets & JSP | Servlet 6.0 / JSP 3.0 |
| **Web Server** | Embedded Jetty / Apache Tomcat | Tomcat 10 |
| **RMI Middleware** | Java RMI (JRMP) | Built-in (JDK) |
| **Database** | SQLite | 3.x |
| **JDBC Driver** | Xerial SQLite-JDBC | 3.45.x |
| **Password Hashing** | jBCrypt | 0.4 |
| **Frontend** | HTML5, CSS3, Bootstrap 5, JavaScript | Bootstrap 5.3 |
| **Development IDE** | IntelliJ IDEA / VS Code | Latest |
| **Version Control** | Git + GitHub | Latest |
| **Containerization** | Docker + Docker Compose | Latest |
| **Cloud Deployment** | Railway | Latest |

#### Project Structure (Maven Multi-Module)

```
remote-exam-result-management-system/
├── pom.xml                    ← Root Maven POM (Parent)
├── common/                    ← Module 1: Shared Interfaces & Models
│   └── src/main/java/common/
│       ├── ExamResultService.java   ← Remote interface
│       ├── User.java
│       ├── Student.java
│       ├── Subject.java
│       ├── ExamResult.java
│       ├── AcademicYear.java
│       └── Semester.java
├── rmi-server/               ← Module 2: Business Logic & Persistence
│   └── src/main/java/server/
│       ├── RMIServer.java
│       ├── ExamResultServiceImpl.java
│       ├── DatabaseConnection.java
│       ├── DatabaseInitializer.java
│       ├── UserDAO.java
│       ├── StudentDAO.java
│       ├── SubjectDAO.java
│       ├── ExamResultDAO.java
│       ├── AcademicYearDAO.java
│       └── SemesterDAO.java
└── web-app/                  ← Module 3: Jakarta Servlet/JSP Front-End
    └── src/main/java/web/
        ├── RMIClientManager.java
        ├── LoginServlet.java
        ├── LogoutServlet.java
        ├── RegisterServlet.java
        ├── AdminDashboardServlet.java
        ├── StudentServlet.java
        ├── SubjectServlet.java
        ├── ExamResultServlet.java
        ├── AcademicServlet.java
        ├── StudentDashboardServlet.java
        ├── StudentResultServlet.java
        └── AuthFilter.java
```

---

## Chapter (2) Remote Method Invocation (RMI)

### 2.1 Remote Method Invocation (RMI)

**Java Remote Method Invocation (Java RMI)** is a Java API that allows an object running in one Java Virtual Machine (JVM) to invoke methods on an object running in another JVM, even across a network. It is Java's native implementation of the **Remote Procedure Call (RPC)** model in an object-oriented context.

In Java RMI, the communication is transparent — the calling code looks almost identical to a regular local method call. Internally, RMI uses the **Java Remote Method Protocol (JRMP)** to serialize method arguments and return values and to transmit them over a network socket.

#### Key RMI Components

| Component | Role |
|:---|:---|
| **Remote Interface** | Defines the methods that can be called remotely. Must extend `java.rmi.Remote`. All methods must declare `throws RemoteException`. |
| **Remote Object (Stub)** | A proxy object on the client side. When a remote method is called, the stub serializes the arguments and forwards the call to the server. |
| **Skeleton** | The server-side counterpart of the stub (handled automatically in modern Java). Receives the call, deserializes arguments, and invokes the actual method on the server object. |
| **RMI Registry** | A name service (like a phone book) that allows clients to look up remote objects by name. The server binds its object to the registry; the client performs a lookup. |
| **UnicastRemoteObject** | The base class for remote objects. It exports the object over TCP and handles the underlying network communication. |

#### RMI Architecture in RERMS

```
┌─────────────────────────────┐        ┌───────────────────────────────────┐
│   Web Application (Client)  │        │    RMI Server (Server)            │
│                             │        │                                   │
│  Jakarta Servlet            │        │  ExamResultServiceImpl            │
│       ↓                     │        │  (extends UnicastRemoteObject)    │
│  RMIClientManager           │◄──────►│       ↓                           │
│  (performs Registry lookup) │  JRMP  │  DAO Layer (UserDAO, StudentDAO,  │
│       ↓                     │  :1099 │   SubjectDAO, ExamResultDAO, etc.)│
│  ExamResultService (Stub)   │        │       ↓                           │
│  (proxy to remote object)   │        │  SQLite Database (JDBC)           │
└─────────────────────────────┘        └───────────────────────────────────┘
```

The Web Application never holds a direct JDBC connection to the SQLite database. All database interactions go exclusively through the RMI remote method calls.

---

### 2.2 Design Issues For RMI

When designing a distributed system using Java RMI, several important issues must be considered:

#### 2.2.1 Serialization

All objects passed as arguments or returned from remote methods must implement `java.io.Serializable`. In RERMS, all domain model classes (`User`, `Student`, `Subject`, `ExamResult`, `AcademicYear`, `Semester`) implement `Serializable` and declare a `serialVersionUID` to ensure version compatibility across JVMs.

#### 2.2.2 RemoteException Handling

All methods declared in a Remote interface must declare `throws RemoteException`. This is a checked exception that captures any network-level failure (e.g., server down, connection timeout). In RERMS, `RemoteException` is also used deliberately to carry server-side validation error messages back to the web client, since RMI serializes exception messages automatically.

```java
// Example: Server rejects duplicate student registration
throw new RemoteException("This email is already registered.");
```

#### 2.2.3 RMI Registry and Port Management

The RMI Registry must be started before any client can perform a lookup. In RERMS, the `RMIServer` starts the registry on **port 1099** (the default RMI registry port) and binds the service under the key `"ExamResultService"`. The web application client performs a lookup using `rmi://localhost:1099/ExamResultService`.

#### 2.2.4 Stub Caching and Connection Reuse

Creating an RMI connection for every HTTP request is expensive. RERMS implements a **Singleton pattern** in `RMIClientManager` — the remote service stub is looked up once and cached for the lifetime of the application. If the connection fails, the manager automatically attempts to reconnect.

#### 2.2.5 Security Considerations

- **Password hashing**: BCrypt is used exclusively on the RMI Server, ensuring plain-text passwords never travel over the network or get stored in the database.
- **Session isolation**: The web application enforces that students can only call `getStudentResults(studentDbId)` with their own session-bound student ID, preventing data leakage.
- **Input validation**: All input validation (field presence, format, uniqueness) is performed on the RMI Server before any database operation, providing a single trusted layer of business logic.

#### 2.2.6 Database Connection Management

The SQLite database is accessed only from the RMI Server. WAL (Write-Ahead Logging) mode is enabled for better concurrent read performance, and foreign key constraints are enforced via `PRAGMA foreign_keys = ON`.

---

### 2.3 Implementation of Remote Invocation Method (RMI)

This section describes how Java RMI is concretely implemented in RERMS across all three Maven modules.

#### Step 1 — Define the Remote Interface (`common` module)

The `ExamResultService` interface is the contract between the client (web app) and the server (RMI server). It extends `java.rmi.Remote` and declares all remotely callable methods, each throwing `RemoteException`.

```java
package common;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

public interface ExamResultService extends Remote {

    // Authentication
    User   login(String email, String password, String role) throws RemoteException;
    boolean registerStudent(String email, String password) throws RemoteException;

    // Student Management
    List<Student> getAllStudents() throws RemoteException;
    List<Student> searchStudents(String keyword) throws RemoteException;
    Student       getStudentById(int id) throws RemoteException;
    Student       getStudentByEmail(String email) throws RemoteException;
    boolean       addStudent(Student student) throws RemoteException;
    boolean       updateStudent(Student student) throws RemoteException;
    boolean       deleteStudent(int id) throws RemoteException;

    // Academic Year & Semester Management
    List<AcademicYear> getAllAcademicYears() throws RemoteException;
    boolean            addAcademicYear(AcademicYear year) throws RemoteException;
    int addAcademicYearWithAutoLink(AcademicYear year, int[] semesterNumbers) throws RemoteException;
    boolean            deleteAcademicYear(int id) throws RemoteException;
    List<Semester>     getSemestersByAcademicYear(int academicYearId) throws RemoteException;
    boolean            addSemester(Semester semester) throws RemoteException;

    // Subject Management
    List<Subject> getAllSubjects() throws RemoteException;
    boolean       addSubject(Subject subject) throws RemoteException;
    boolean       updateSubject(Subject subject) throws RemoteException;
    boolean       deleteSubject(int id) throws RemoteException;
    int           assignSubjectsToSemester(int semesterId, int[] subjectIds) throws RemoteException;
    boolean       detachSubjectFromSemester(int subjectId) throws RemoteException;

    // Exam Result Management
    List<ExamResult> getAllResults() throws RemoteException;
    List<ExamResult> getStudentResults(int studentDbId) throws RemoteException;
    boolean          addExamResult(ExamResult result) throws RemoteException;
    boolean          updateExamResult(ExamResult result) throws RemoteException;
    boolean          deleteExamResult(int id) throws RemoteException;

    // Analytics
    double calculateAverage(List<ExamResult> results) throws RemoteException;
    double calculateCGPA(List<ExamResult> results) throws RemoteException;
    String calculateOverallGrade(double averagePercentage) throws RemoteException;

    // Dashboard Statistics
    int              getTotalStudents() throws RemoteException;
    int              getTotalSubjects() throws RemoteException;
    int              getTotalResults() throws RemoteException;
    List<ExamResult> getRecentResults(int limit) throws RemoteException;
}
```

#### Step 2 — Implement the Remote Object (`rmi-server` module)

`ExamResultServiceImpl` extends `UnicastRemoteObject` (which makes it a network-exportable remote object) and implements `ExamResultService`. This class runs exclusively on the RMI Server.

```java
package server;

import common.*;
import org.mindrot.jbcrypt.BCrypt;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

public class ExamResultServiceImpl
        extends UnicastRemoteObject
        implements ExamResultService {

    private final UserDAO       userDAO       = new UserDAO();
    private final StudentDAO    studentDAO    = new StudentDAO();
    private final SubjectDAO    subjectDAO    = new SubjectDAO();
    private final ExamResultDAO resultDAO     = new ExamResultDAO();
    private final AcademicYearDAO academicYearDAO = new AcademicYearDAO();
    private final SemesterDAO     semesterDAO     = new SemesterDAO();

    public ExamResultServiceImpl() throws RemoteException {
        super(); // Exports this object over UnicastRemoteObject
    }

    @Override
    public User login(String email, String password, String role)
            throws RemoteException {
        User user = userDAO.findByEmailAndRole(email.trim(), role.trim().toUpperCase());
        if (user == null) return null;
        if (!BCrypt.checkpw(password, user.getPassword())) return null;
        user.setPassword(null); // Never return the password hash
        return user;
    }

    @Override
    public boolean addExamResult(ExamResult result) throws RemoteException {
        validateResult(result);
        if (resultDAO.existsDuplicate(result.getStudentId(),
                result.getSubjectId(), result.getExamType(), 0)) {
            throw new RemoteException("A result for this student and subject already exists.");
        }
        // Grade is calculated exclusively on the server
        result.setGrade(computeGrade(result.getMarks(), result.getTotalMarks()));
        return resultDAO.insert(result);
    }

    // Grading engine — UCS Hpa-an official 10-tier scale
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
    // ... (all other method implementations)
}
```

#### Step 3 — Start the RMI Registry and Bind the Service (`RMIServer`)

```java
package server;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class RMIServer {
    private static final int RMI_PORT = 1099;

    public static void main(String[] args) throws Exception {
        // Initialize SQLite DB schema and seed data
        DatabaseInitializer.initialize();

        // Create and export the remote service object
        ExamResultServiceImpl service = new ExamResultServiceImpl();

        // Start local RMI registry on port 1099
        Registry registry = LocateRegistry.createRegistry(RMI_PORT);

        // Bind the service to the registry under the key "ExamResultService"
        registry.rebind("ExamResultService", service);

        System.out.println("RMI Registry started on port " + RMI_PORT);
        System.out.println("ExamResultService bound successfully. RMI Server is ready.");
    }
}
```

#### Step 4 — Look Up the Remote Service on the Client (`web-app` module)

`RMIClientManager` is a Singleton that manages the remote stub. It performs the registry lookup once and caches the stub for reuse across all HTTP requests.

```java
package web;

import common.ExamResultService;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class RMIClientManager {

    private static ExamResultService service = null;
    private static final String RMI_HOST = "localhost";
    private static final int    RMI_PORT = 1099;
    private static final String SERVICE_NAME = "ExamResultService";

    // Singleton access — cached stub is reused for all HTTP requests
    public static synchronized ExamResultService getService() {
        if (service == null) {
            try {
                Registry registry = LocateRegistry.getRegistry(RMI_HOST, RMI_PORT);
                service = (ExamResultService) registry.lookup(SERVICE_NAME);
            } catch (Exception e) {
                throw new RuntimeException("Cannot connect to RMI Server: " + e.getMessage(), e);
            }
        }
        return service;
    }
}
```

#### Step 5 — Call Remote Methods from Servlets

Any Jakarta Servlet can invoke remote methods through `RMIClientManager.getService()`, exactly as if calling a local method:

```java
// Inside ExamResultServlet.java (doPost method)
ExamResultService service = RMIClientManager.getService();

ExamResult result = new ExamResult();
result.setStudentId(Integer.parseInt(request.getParameter("studentId")));
result.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
result.setMarks(Double.parseDouble(request.getParameter("marks")));
result.setTotalMarks(Double.parseDouble(request.getParameter("totalMarks")));
result.setExamType(request.getParameter("examType"));

// Remote method call — grade is calculated and set by the server
boolean success = service.addExamResult(result);
```

---

## Chapter (3) Implementation

This chapter presents the complete system implementation through a step-by-step walkthrough of each screen, demonstrating how users interact with the Remote Exam Result Management System (RERMS).

---

### 3.1 Role Selection Page

**URL:** `http://localhost:8080/remote-exam-result-management-system/`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │         [ INSERT ROLE SELECTION PAGE             │
> │               SCREENSHOT HERE ]                 │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

When a user first opens the system in a browser, they are greeted by the **Role Selection Page**. This page is the entry point to the entire system and requires the user to identify themselves before proceeding.

**Page Elements:**
- A centered card with the university name and system title
- Two clearly labelled role buttons: **"Admin"** and **"Student"**
- Each button navigates to the respective login page

**How it works:**
1. Open a browser and navigate to `http://localhost:8080/remote-exam-result-management-system/`
2. The system displays two options: **Admin** and **Student**
3. Click **Admin** to go to the Admin login page, or click **Student** to go to the Student login page

---

### 3.2 Login Page

**URL:** `/login`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │           [ INSERT LOGIN PAGE                    │
> │               SCREENSHOT HERE ]                 │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Login Page** is a glassmorphism-style form with a dark background. It accepts the user's email and password credentials. The login page is shared between Admin and Student roles but routes to different dashboards after successful authentication.

**Page Elements:**
- Email address input field
- Password input field (masked)
- "Login" submit button
- Link to the Student Registration page (for new students)

**How to Login (Admin):**
1. Enter Email: `admin@example.com`
2. Enter Password: `admin123`
3. Click the **Login** button
4. Upon success, the system redirects to the **Admin Dashboard**

**How to Login (Student):**
1. Enter Email: `john.doe@university.edu`
2. Enter Password: `student123`
3. Click the **Login** button
4. Upon success, the system redirects to the **Student Dashboard**

**Backend Process:**
- The `LoginServlet` calls `RMIClientManager.getService().login(email, password, role)` via Java RMI
- On the RMI Server, `ExamResultServiceImpl.login()` looks up the user by email and role in the `users` table
- The submitted password is verified against the stored BCrypt hash using `BCrypt.checkpw()`
- If credentials are valid, a session is created with the user's email, role, and student database ID (for students)
- If credentials are invalid, an error message is displayed on the login page

---

### 3.3 Student Registration Page

**URL:** `/register`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │         [ INSERT STUDENT REGISTRATION            │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

New students who have been admitted by the Admin can create their own login accounts through the **Registration Page**. Students who are not in the Admin's admitted student list cannot register.

**Page Elements:**
- Email address input field
- Password input field
- Confirm password input field
- "Register" submit button

**How to Register:**
1. Navigate to `http://localhost:8080/remote-exam-result-management-system/register`
2. Enter your university email address (must match the email that the Admin entered in the student list)
3. Enter a password (minimum 6 characters)
4. Confirm the password
5. Click **Register**
6. If the email is in the admitted student list and not yet registered, the account is created and you are redirected to the login page

**Security Rules:**
- The email must already exist in the `students` table (admission list check)
- Duplicate registrations with the same email are rejected
- The password is hashed using BCrypt (cost factor 12) before being stored in the `users` table

---

### 3.4 Admin Dashboard

**URL:** `/admin/dashboard`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │           [ INSERT ADMIN DASHBOARD               │
> │               SCREENSHOT HERE ]                 │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

After a successful Admin login, the system redirects to the **Admin Dashboard**. This is the central control panel for the administrator.

**Page Elements:**
- **Left Sidebar Navigation** with links to all admin sections (Dashboard, Students, Academics, Subjects, Results)
- **Statistics Cards** showing live counts:
  - Total Students registered in the system
  - Total Subjects created
  - Total Exam Results recorded
- **RMI Server Status Badge** — displays `Java RMI Server Connected` in green if the RMI Server is reachable on port 1099
- **Quick Action Cards** — shortcut buttons to navigate to Students, Subjects, and Results pages
- **Recent Exam Results Table** — shows the 5 most recently entered exam results

**How it works:**
1. The `AdminDashboardServlet` calls three remote methods via RMI: `getTotalStudents()`, `getTotalSubjects()`, `getTotalResults()`, and `getRecentResults(5)`
2. All counts are fetched from the SQLite database through the RMI Server's DAO layer
3. The JSP view renders the numbers dynamically into the statistics cards

---

### 3.5 Student Management Page

**URL:** `/admin/students`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │        [ INSERT STUDENT MANAGEMENT               │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Student Management Page** allows the Admin to manage all student profiles in the system. Students listed here are considered "admitted students" and are the only ones allowed to create portal accounts.

**Page Elements:**
- **Search Bar** — live keyword search by student name or student ID
- **"Add Student" Button** — opens a modal form to add a new student
- **Students Table** showing: Roll No., Student Name, Email, Phone, Gender, and Action buttons (Edit / Delete)
- **Edit Modal** — pre-filled form to update an existing student's details
- **Delete Confirmation Modal** — confirms before permanently deleting a student

**How to Add a Student:**
1. Click the **"+ Add Student"** button
2. In the modal form, fill in:
   - Student ID (Roll No.) — e.g., `ST001`
   - Full Name
   - Email Address
   - Phone Number
   - Gender
3. Click **"Save"**
4. The system calls `service.addStudent(student)` via RMI
5. The RMI Server validates the data and checks for duplicate student ID or email
6. On success, the student is added and the table refreshes

**How to Edit a Student:**
1. Click the **✏️ Edit** button next to the student's row
2. The edit modal opens pre-filled with the student's current data
3. Modify the required fields and click **"Update"**
4. The system calls `service.updateStudent(student)` via RMI

**How to Delete a Student:**
1. Click the **🗑️ Delete** button next to the student's row
2. A confirmation modal appears asking "Are you sure?"
3. Click **"Yes, Delete"** to confirm
4. The system calls `service.deleteStudent(id)` via RMI
5. The student and all their associated exam results are deleted (CASCADE)

**Live Search:**
- Type any keyword in the search bar (name or student ID)
- The table filters in real-time using JavaScript without a page reload

---

### 3.6 Academic Year & Semester Management Page

**URL:** `/admin/academics`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │        [ INSERT ACADEMICS MANAGEMENT             │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Academics Page** allows the Admin to create and manage academic years and their semesters. This is the structural foundation that subjects and exam results are built on top of.

**Page Elements:**
- **"Add Academic Year" Button** — opens a modal to create a new academic year
- **Accordion List** — each academic year expands to show its semesters and the subjects assigned to each semester
- **Assign Subjects Button** — opens a modal to assign existing subjects to a semester
- **Detach Button** — removes a subject from a semester (returns it to the unassigned pool)

**How to Add an Academic Year:**
1. Click **"+ Add Academic Year"**
2. Enter the academic year in format `YYYY-YYYY` (e.g., `2024-2025`)
3. Select which semesters (1–8) to auto-create for this year
4. Click **"Save"**
5. The system calls `service.addAcademicYearWithAutoLink(year, semesterNumbers)` via RMI
6. The RMI Server creates the academic year, creates the selected semesters, and automatically links any subjects whose stored semester number matches

**How to Assign Subjects to a Semester:**
1. Click the **"Assign Subjects"** button inside a semester accordion
2. A modal shows all available unassigned subjects
3. Select the subjects to assign (checkboxes)
4. Click **"Assign"**
5. The system calls `service.assignSubjectsToSemester(semesterId, subjectIds)` via RMI

---

### 3.7 Subject Management Page

**URL:** `/admin/subjects`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │         [ INSERT SUBJECT MANAGEMENT              │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Subject Management Page** allows the Admin to create and manage course subjects. Subjects are created independently and can later be assigned to semesters within academic years.

**Page Elements:**
- **"Add Subject" Button** — opens a modal to create a new subject
- **Search Bar** — keyword search by subject code or name
- **Subjects Table** showing: Subject Code, Subject Name, Credits, Department, Semester No., and Action buttons

**How to Add a Subject:**
1. Click the **"+ Add Subject"** button
2. In the modal form, fill in:
   - Subject Code (e.g., `CS101`)
   - Subject Name (e.g., `Introduction to Programming`)
   - Credit Units (1–6)
   - Department (e.g., `Computer Science`)
   - Semester Number (1–8)
3. Click **"Save"**
4. The system calls `service.addSubject(subject)` via RMI
5. The RMI Server checks for duplicate subject codes and saves the subject

**How to Edit / Delete a Subject:**
- Click **✏️ Edit** to open the edit modal with pre-filled data
- Click **🗑️ Delete** to open the delete confirmation modal
- Deleting a subject also deletes all associated exam results (CASCADE)

---

### 3.8 Exam Result Management Page

**URL:** `/admin/results`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │        [ INSERT EXAM RESULT MANAGEMENT           │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Exam Result Management Page** is where the Admin enters, updates, and manages all exam results. The grade is automatically calculated by the RMI Server — the Admin only needs to enter the marks.

**Page Elements:**
- **Filter Bar** — filter results by Student, Subject, Semester, and Academic Year
- **"Add Result" Button** — opens a modal to enter a new exam result
- **Results Table** showing: Student Name, Subject, Marks, Grade Badge, Exam Type, and Actions
- **Add/Edit Result Modal** with dropdowns for Student, Subject, Exam Type, and input fields for Marks and Total Marks

**How to Add an Exam Result:**
1. Click the **"+ Add Result"** button
2. In the modal:
   - Select the **Student** from the dropdown
   - Select the **Subject** from the dropdown
   - Select **Exam Type**: `REGULAR` or `RE-EXAM`
   - Enter **Marks Obtained** (e.g., `85`)
   - Enter **Total Marks** (e.g., `100`)
3. Click **"Save"**
4. The system sends the result to the RMI Server via `service.addExamResult(result)`
5. The RMI Server:
   - Validates the marks (marks ≤ total marks, no negatives)
   - Checks for duplicate results (same student + subject + exam type)
   - Calculates the grade automatically using `computeGrade(marks, totalMarks)`
   - Saves the result with the computed grade to the database
6. The table refreshes showing the new result with the auto-calculated grade badge

**How to Filter Results:**
1. Use the dropdown filters at the top of the page:
   - Select a **Student** to see only their results
   - Select a **Subject** to see results for that subject
   - Select a **Semester** to filter by semester
   - Select an **Academic Year** to filter by year
2. The table updates to show only matching results

**Grade Auto-Calculation Example:**
| Marks Entered | Total Marks | Percentage | Auto-Calculated Grade |
|:---:|:---:|:---:|:---:|
| 92 | 100 | 92% | **A+** |
| 83 | 100 | 83% | **A** |
| 76 | 100 | 76% | **A-** |
| 45 | 100 | 45% | **D** |
| 35 | 100 | 35% | **F** |

---

### 3.9 Student Dashboard

**URL:** `/student/dashboard`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │          [ INSERT STUDENT DASHBOARD              │
> │               SCREENSHOT HERE ]                 │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

After a successful Student login, the system redirects to the **Student Dashboard**. This is the student's personal home page showing their academic summary at a glance.

**Page Elements:**
- **Hero Welcome Banner** — displays the student's name, roll number, and avatar initials in a blue gradient card with a "View My Results" button
- **CGPA Card** — shows the student's overall CGPA on the 4.0 scale (e.g., `3.75 / 4.0`)
- **Average Score Card** — shows the overall percentage average and corresponding grade
- **Passed Subjects Card** — shows passed vs. total subjects count (e.g., `5 / 5`)
- **Profile Info Card** — displays email, phone, gender, and enrolment date
- **Recent Results Table** — shows the 5 most recent exam results with subject code, name, marks, and grade badge

**How it works:**
1. The `StudentDashboardServlet` retrieves the logged-in student's database ID from the HTTP session
2. It calls `service.getStudentByEmail(sessionEmail)` to get the student's profile via RMI
3. It calls `service.getStudentResults(studentDbId)` to get all the student's exam results via RMI
4. It calls `service.calculateCGPA(results)` and `service.calculateAverage(results)` to compute the academic summary via RMI
5. All data is passed to the JSP view for rendering

---

### 3.10 Student Exam Results Page

**URL:** `/student/results`

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │          [ INSERT STUDENT RESULTS                │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **My Results Page** shows the student's complete academic record, organized by academic year and semester in an expandable accordion layout.

**Page Elements:**
- **Accordion by Academic Year** — each academic year is a collapsible section
- **Semester Sub-Groups** — within each year, results are grouped by semester
- **Results Table per Semester** showing:
  - Subject Code and Subject Name
  - Marks Obtained / Total Marks
  - Grade Badge (colour-coded)
  - Pass / Fail Status Pill
  - Exam Type (REGULAR / RE-EXAM)
- **"Print Transcript" Button** — opens the official A4 print view

**Grade Badge Colour Coding:**
| Grade | Badge Colour |
|:---:|:---|
| A+, A | 🟢 Green |
| A-, B+, B, B- | 🔵 Blue |
| C+, C | 🟡 Yellow |
| D | 🟠 Orange |
| F | 🔴 Red |

**Privacy Protection:**
- Students can only see their own results
- The `StudentResultServlet` retrieves the student's database ID from the session and calls `service.getStudentResults(studentDbId)` directly — there is no URL parameter for the student ID, making URL manipulation impossible

---

### 3.11 Official Academic Transcript Print View

**URL:** `/student/results` → Click "Print Transcript"

> **📸 Screenshot Placeholder**
> ```
> ┌──────────────────────────────────────────────────┐
> │                                                  │
> │         [ INSERT PRINT TRANSCRIPT                │
> │               PAGE SCREENSHOT HERE ]            │
> │                                                  │
> └──────────────────────────────────────────────────┘
> ```

The **Official Academic Transcript** is a printable A4-format document that can be printed directly from the browser or saved as a PDF using the browser's "Print to PDF" function.

**Transcript Contents:**
1. **University Header** — University of Computer Studies (Hpa-an) name and "Academic Record" title
2. **Student Information Table**:
   - Roll Number / Student ID
   - Full Name
   - Academic Year
   - Semester
   - Degree Programme: Bachelor of Computer Science (B.C.Sc.)
   - Specialization: Computer Science
3. **Course Results Table**:
   - No., Course Code, Course Name, Academic Credit Units, Grade Obtained, Grade Score (4.0 scale), Grade Points (Credit × Grade Score)
4. **Summary Row** — Total Credit Units, Total Grade Points, Cumulative GPA, Overall GPA
5. **Official Grading Scale Grid** — Reference table of all grades and their point values
6. **Issue Date** and **Registrar Signature Block**

**How to Print / Save as PDF:**
1. On the Student Results page, click the **"🖨️ Print Transcript"** button
2. The browser opens the print-optimized A4 view
3. Use `Ctrl+P` (or `Cmd+P` on Mac) to open the browser print dialog
4. Select **"Save as PDF"** as the printer destination to save a digital copy
5. Click **"Print"** to send to a physical printer

## Chapter (4) Conclusion

The **Remote Exam Result Management System (RERMS)** was successfully designed, developed, and tested as a complete enterprise-grade distributed application for the University of Computer Studies, Hpa-an.

### 4.1 Summary of Achievements

The following project objectives were fully achieved:

1. ✅ **Java RMI Distributed Middleware** — Java RMI (port 1099) was successfully implemented as the sole communication bridge between the web application and the database server. The web application never holds a direct JDBC connection to the database.

2. ✅ **Role-Based Access Control** — A Jakarta Servlet `AuthFilter` enforces strict RBAC, separating administrator and student capabilities with session-based security and HTTP 403 responses for unauthorized access attempts.

3. ✅ **Automated Grading Engine** — A server-side grading engine consistently computes grades per the official UCS Hpa-an 10-tier scale and calculates credit-weighted CGPA on a 4.0 scale.

4. ✅ **Normalized Relational Database** — A 5-table SQLite schema with a clear `academic_years → semesters → subjects → exam_results` hierarchy was implemented with foreign key constraints, unique indexes, and WAL mode.

5. ✅ **Full Admin CRUD Operations** — Administrators can manage students, academic years, semesters, subjects, and exam results with full create, read, update, and delete capabilities, including multi-criteria search and filtering.

6. ✅ **Student Self-Service Portal** — Students can securely access their personal dashboard, view semester-wise results with colour-coded grade badges, and generate official A4 academic transcripts with university header, GPA summary, and registrar signature block.

7. ✅ **Secure Password Management** — All passwords are stored as BCrypt hashes (cost factor 12). Plain-text passwords are never stored, logged, or returned from the server.

8. ✅ **Production Deployment** — The system is containerized using Docker and deployable on Railway cloud infrastructure.

### 4.2 Lessons Learned

- **RMI is an effective distributed middleware** for intranet applications. Its transparency (remote calls look like local calls) greatly simplifies development, though careful attention to `RemoteException` handling and object serialization is required.
- **Separation of concerns** through the three-module Maven structure (common, rmi-server, web-app) made the system maintainable and extensible.
- **Server-side validation** as the single trusted layer (rather than relying on client-side JavaScript alone) is essential for security and data integrity in distributed systems.

### 4.3 Future Improvements

The following enhancements are planned for future development:

1. **PDF Export** — Server-side PDF generation of official academic transcripts using Apache PDFBox or iText, allowing transcripts to be downloaded as `.pdf` files.

2. **SSL/TLS for RMI** — Enable `SslRMIClientSocketFactory` and `SslRMIServerSocketFactory` to encrypt all RMI communication over public networks, replacing the current plain JRMP protocol.

3. **Email Notifications** — Automated email alerts sent to students when new exam results are published, using Jakarta Mail (JavaMail API).

4. **Mobile Companion App** — A Flutter-based mobile application for students to conveniently check grades, CGPA, and download transcripts from their smartphones.

5. **Advanced Analytics Dashboard** — Charts and graphs for administrators showing grade distributions, pass/fail ratios, department-wise performance comparisons, and semester trends.

---

## References

1. Oracle Corporation. (2024). *Java Remote Method Invocation (RMI) Specification*. Retrieved from https://docs.oracle.com/en/java/javase/21/docs/specs/rmi/

2. Oracle Corporation. (2024). *Java SE 21 API Documentation — java.rmi Module*. Retrieved from https://docs.oracle.com/en/java/javase/21/docs/api/java.rmi/module-summary.html

3. The Apache Software Foundation. (2024). *Apache Maven Documentation — Multi-Module Projects*. Retrieved from https://maven.apache.org/guides/mini/guide-multiple-modules.html

4. Eclipse Foundation. (2024). *Jakarta EE 10 Platform Specification — Servlet 6.0*. Retrieved from https://jakarta.ee/specifications/servlet/6.0/

5. SQLite Consortium. (2024). *SQLite Documentation*. Retrieved from https://www.sqlite.org/docs.html

6. Xerial. (2024). *SQLite JDBC Driver for Java*. Retrieved from https://github.com/xerial/sqlite-jdbc

7. Provos, N., & Mazières, D. (1999). *A Future-Adaptable Password Scheme*. USENIX Annual Technical Conference. (jBCrypt implementation: https://www.mindrot.org/projects/jBCrypt/)

8. Bootstrap Team. (2024). *Bootstrap 5 Documentation*. Retrieved from https://getbootstrap.com/docs/5.0/

9. Coulouris, G., Dollimore, J., Kindberg, T., & Blair, G. (2011). *Distributed Systems: Concepts and Design* (5th ed.). Addison-Wesley.

10. Silberschatz, A., Korth, H. F., & Sudarshan, S. (2020). *Database System Concepts* (7th ed.). McGraw-Hill.

11. Bloch, J. (2018). *Effective Java* (3rd ed.). Addison-Wesley. *(Chapter on Serialization and RMI)*

---

*End of Documentation*

**Document prepared by:** Final Year Project Team  
**University:** University of Computer Studies, Hpa-an (UCS Hpa-an)  
**Academic Year:** 2024–2025
