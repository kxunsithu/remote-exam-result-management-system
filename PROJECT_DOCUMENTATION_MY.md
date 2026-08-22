# 🎓 ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ) — စာမေးပွဲရလဒ် စီမံခန့်ခွဲမှု စနစ်
## Remote Exam Result Management System (RERMS) — အပြည့်အစုံ လုပ်ဆောင်ချက် မှတ်တမ်း (Full Feature Documentation)

---

## 📌 ၁။ စနစ် နိဒါန်းနှင့် အဓိက ပန်းတိုင် (System Overview & Core Objectives)

**Remote Exam Result Management System (RERMS)** သည် **ကွန်ပျူတာတက္ကသိုလ် (ဘားအံ)** [University of Computer Studies (Hpa-an) - UCS(Hpa-an)] ၏ ကျောင်းသား/သူများ၏ စာမေးပွဲ ရလဒ်များကို အချိန်နှင့်တပြေးညီ လုံခြုံစိတ်ချစွာ စီမံခန့်ခွဲနိုင်ရန်၊ Grade များနှင့် CGPA များကို တက္ကသိုလ် စံနှုန်းအတိုင်း မမှားယွင်းဘဲ မိုဘိုင်းနှင့် ကွန်ပျူတာ စက်ပစ္စည်းအားလုံးတွင် ကြည့်ရှုနိုင်ရန်နှင့် တရားဝင် **Academic Record (ကျောင်းသား အမှတ်စာရင်း)** များကို A4 ပုံစံဖြင့် ထုတ်ယူနိုင်ရန် ထုတ်လုပ်ထားသော **Enterprise Multi-Module Distributed Application** ဖြစ်ပါသည်။

---

## 🏗️ ၂။ စနစ် နည်းပညာနှင့် တည်ဆောက်ပုံ (Architecture, Tech Stack & Security)

စနစ်အား **Three-Tier Architecture** ဖြင့် တည်ဆောက်ထားပါသည်-

```
[ Frontend Client: Servlets / JSP / CSS3 / Bootstrap 5 / JS ]
                           │
                           ▼ (Java RMI Distributed Protocol - Port 1099)
[ Middle Tier: Java RMI Business Logic Server (ExamResultServiceImpl) ]
                           │
                           ▼ (JDBC Relational Connection)
[ Database Tier: SQLite Embedded DB (ExamResult.db) & BCrypt Encryption ]
```

### နည်းပညာ သတ်မှတ်ချက်များ (Tech Stack Specs)

1. **Frontend Layer**:
   - **HTML5 / JSP (JavaServer Pages 3.0)**: Dynamic Template Display.
   - **CSS3 Design System**: Responsive Multi-Breakpoint System (`≤480px` Mobile, `768px-1024px` Tablet, `≥1280px` Desktop).
   - **Micro-Animations & Glassmorphism**: Cards `@keyframes slideUpFade` entrance physics, hover lifts (`transform: translateY(-3px)`), Primary Blue (`#2563eb` / `#1d4ed8`) theme.
2. **Backend / Middle Tier**:
   - **Jakarta EE Servlets**: Controller handling authentication, routing, and user input validation.
   - **Java RMI (Remote Method Invocation)**: Server-side business logic processing, grade calculation, and data validation.
3. **Database & Security Layer**:
   - **SQLite Relational DB**: Foreign key constraint enforcement (`PRAGMA foreign_keys = ON`).
   - **BCrypt Password Hashing**: Passwords stored using `BCrypt.hashpw(password, BCrypt.gensalt(12))`.

---

## 👥 ၃။ စီမံခန့်ခွဲသူ ဘက်ဆိုင်ရာ အသေးစိတ် လုပ်ဆောင်ချက်များ (Admin Role Detailed Features)

Admin သည် စနစ်တစ်ခုလုံး၏ ကျောင်းသား၊ သင်ရိုး၊ ဘာသာရပ်နှင့် ရလဒ်များကို ထိန်းချုပ်ခွင့်ရှိသော ဘက်ဖြစ်ပါသည်။

---

### ၃.၁။ စနစ်သို့ ဝင်ရောက်ခြင်းနှင့် Session ထိန်းသိမ်းခြင်း (Admin Authentication)
- **Role Selection**: ဝင်ရောက်ရန် Welcome Screen (`role-select.jsp`) တွင် Admin ဘက်ကို ရွေးချယ်ခြင်း။
- **BCrypt Credential Verification**: Admin အီးမေးလ် (`admin@example.com`) နှင့် စကားဝှက် (`admin123`) ဖြင့် ဝင်ရောက်ခြင်း။
- **Session Security**: Admin Logged In State အား HTTP Session တွင် လုံခြုံစွာ မှတ်သားထားပြီး၊ Logout မလုပ်မချင်း သို့မဟုတ် Session သက်တမ်း ကုန်သည်အထိ ထိန်းသိမ်းထားခြင်း။
- **Global Logout Confirmation Modal**: Navbar ရှိ Logout (ထွက်မည်) ကို နှိပ်ပါက Confirmation Modal ပေါ်ပေါက်ပြီး အတည်ပြုမှသာ ထွက်ခွာခြင်း။

---

### ၃.၂။ Admin ပင်မ ဒက်ရှ်ဘုတ် (Admin Dashboard & Overview Analytics)
- **စနစ် အခြေအနေ အနှစ်ချုပ် (Overview Stats)**:
  - **ကျောင်းသား/သူ ဦးရေ (Total Students)**: စနစ်တွင် စာရင်းသွင်းထားသော စုစုပေါင်း ကျောင်းသား အရေအတွက်။
  - **ဘာသာရပ် အရေအတွက် (Total Subjects)**: သင်ရိုးညွှန်းတမ်းတွင် ထည့်သွင်းထားသော စုစုပေါင်း ဘာသာရပ် အရေအတွက်။
  - **စာမေးပွဲ ရလဒ် အရေအတွက် (Total Results)**: ထည့်သွင်းထားသော စုစုပေါင်း စာမေးပွဲ ရလဒ် စေတနာ အရေအတွက်။
- **RMI Server ချိတ်ဆက်မှု အခြေအနေ (Connection Indicator)**: `Java RMI Server Connected` Badge ဖြင့် Middleware Server စနစ်မောင်းနှင်နေမှုကို အချိန်နှင့်တပြေးညီ ပြသခြင်း။
- **Quick Action Shortcuts**: ကျောင်းသား စီမံခန့်ခွဲမှု၊ ဘာသာရပ် စီမံခန့်ခွဲမှု၊ စာမေးပွဲ ရလဒ် ထည့်သွင်းမှု သို့ တိုက်ရိုက် သွားရောက်နိုင်သော Interactive Cards များ။

---

### ၃.၃။ ဝင်ခွင့်ရ ကျောင်းသားများ စီမံခန့်ခွဲခြင်း (Student Management - Detailed)
- **ဝင်ခွင့်ရ ကျောင်းသားသစ် ထည့်သွင်းခြင်း (Add Student)**:
  - Modal Form မှတစ်ဆင့် ကျောင်းသား ခုံနံပါတ် (Roll No / Student ID - e.g. `ST001`)၊ အမည်၊ အီးမေးလ်၊ ဖုန်းနံပါတ်၊ ကျား/မ စသည်တို့ကို ထည့်သွင်းခြင်း။
  - **အီးမေးလ် ထပ်နေမှု စိစစ်ခြင်း**: ခုံနံပါတ် သို့မဟုတ် အီးမေးလ် ထပ်နေပါက Server မှ တားမြစ်ခြင်း။
- **ကျောင်းသား အချက်အလက် ပြင်ဆင်ခြင်း (Edit Student)**:
  - ကျောင်းသား၏ အမည်၊ ဖုန်းနံပါတ်၊ ကျား/မ စသည်တို့ကို အချိန်မရွေး ပြန်လည်ပြင်ဆင်နိုင်ခြင်း။
- **ကျောင်းသား ပယ်ဖျက်ခြင်း (Delete Student)**:
  - Delete ✏️ Icon နှိပ်ပါက `globalDeleteModal` ပေါ်ပေါက်ပြီး အတည်ပြုမှသာ ပယ်ဖျက်ခြင်း။
- **အချိန်နှင့်တပြေးညီ ရှာဖွေခြင်း (Live Keyword Search)**:
  - ရှာဖွေလိုသော ခုံနံပါတ် သို့မဟုတ် အမည် ရိုက်ထည့်သည်နှင့် စာရင်းအား အချိန်နှင့်တပြေးညီ Filter ပြုလုပ်ပေးခြင်း။
- **ကျောင်းသား ဝင်ခွင့် စိစစ်ရေး မူဝါဒ (Admission List Enforcement for Registration)**:
  - Admin ထည့်သွင်းထားသော ကျောင်းသား အီးမေးလ်များသာ ကျောင်းသား အကောင့်သစ် (Student Registration) စာရင်းသွင်းခွင့် ရရှိမည်ဖြစ်သည်။

---

### ၃.၄။ ပညာသင်နှစ်နှင့် Semester များ စီမံခန့်ခွဲခြင်း (Academic Years & Semesters)
- **ပညာသင်နှစ်သစ် သတ်မှတ်ခြင်း (Add Academic Year)**:
  - ပညာသင်နှစ် ပုံစံအား `YYYY-YYYY` (e.g. `2024-2025`) စံနှုန်းအတိုင်း ရိုက်ထည့်ရမည်ဖြစ်ပြီး Regex ဖြင့် တိကျစွာ စိစစ်ပါသည်။
- **Semester ခွဲဝေခြင်း (Semester Management)**:
  - ပညာသင်နှစ် တစ်ခုစီအောက်တွင် Semester 1 မှ Semester 8 အထိ သတ်မှတ် ထည့်သွင်းနိုင်ခြင်း။
- **Accordion View Structure**:
  - ပညာသင်နှစ် အလိုက် Collapsible Accordion ဖြင့် ပြသထားပြီး ပညာသင်နှစ်တစ်ခုစီအောက်ရှိ Semester များနှင့် သင်ယူရမည့် ဘာသာရပ်များကို ရှင်းလင်းစွာ ကြည့်ရှုနိုင်ခြင်း။
- **Semester သို့ ဘာသာရပ် တပ်ဆင်ခြင်း (Assign / Detach Subjects)**:
  - ဘာသာရပ် ရေကန် (Subject Pool) မှ ဘာသာရပ်များကို သက်ဆိုင်ရာ Semester သို့ တိုက်ရိုက် မိန့်ဆက်ခြင်း သို့မဟုတ် ပြန်လည် ဖြုတ်ယူခြင်း။

---

### ၃.၅။ သင်ရိုးညွှန်းတမ်း ဘာသာရပ်များ စီမံခန့်ခွဲခြင်း (Subject Management)
- **ဘာသာရပ်သစ် ဖန်တီးခြင်း (Add Subject)**:
  - ဘာသာရပ် သင်္ကေတ (Subject Code - e.g., `CS101`)၊ ဘာသာရပ် အမည် (e.g., `Java Programming`)၊ Credit Unit (1 မှ 6 Credit အထိ)၊ ဌာန (Department) သတ်မှတ်ခြင်း။
- **ဘာသာရပ် သင်္ကေတ ထပ်နေမှု စိစစ်ခြင်း**:
  - ပညာသင်နှစ် တစ်ခုအတွင်း Subject Code ထပ်မံ ထည့်သွင်းခြင်း မရှိစေရန် Server မှ တားမြစ်ခြင်း။

---

### ၃.၆။ စာမေးပွဲ ရလဒ်များ စီမံခန့်ခွဲခြင်း (Exam Result Management)
- **ရလဒ် ထည့်သွင်းခြင်း (Add Result)**:
  - ကျောင်းသား ရွေးချယ်ခြင်း၊ ဘာသာရပ် ရွေးချယ်ခြင်း၊ စာမေးပွဲ အမျိုးအစား (`REGULAR` သို့မဟုတ် `RE-EXAM`) နှင့် ရရှိမှတ် (Marks Obtained vs Total Marks) ထည့်သွင်းခြင်း။
- **Grade တွက်ချက်ခြင်း**:
  - Server မှ ရမှတ် ရာခိုင်နှုန်းကို တွက်ချက်၍ UCS(Hpa-an) စံနှုန်းအတိုင်း Grade (`A+` မှ `F`) ကို စက္ကန့်ပိုင်းအတွင်း သတ်မှတ်ပေးခြင်း။
- **ထပ်နေသော ရလဒ် စိစစ်ခြင်း (Duplicate Prevention)**:
  - ကျောင်းသားတစ်ဦးတည်း၏ ဘာသာရပ်တစ်ခုအတွက် ရလဒ် နှစ်ကြိမ် ထပ်မံ မဝင်စေရန် တားမြစ်ခြင်း။

---

### ၃.၇။ ကျောင်းသား အသေးစိတ် ရလဒ်နှင့် တက္ကသိုလ် တရားဝင် Print ထုတ်ယူခြင်း (Student Result Detail & Official Printing)
- Admin သည် ကျောင်းသားတစ်ဦးစီ၏ ရလဒ် အသေးစိတ် စာမျက်နှာ (`student-result-detail.jsp`) တွင် ကျောင်းသား၏ Semesters အလိုက် ရလဒ်များကို စိစစ်နိုင်ပါသည်။
- **Official Academic Record Transcript Printing**:
  - Print 🖨️ Button ကို နှိပ်ပါက **"University of Computer Studies (Hpa-an)"** တရားဝင် အမှတ်စာရင်း ပုံစံ (result.png စံနှုန်းအတိုင်း) A4 Format ဖြင့် ထွက်ရှိလာမည် ဖြစ်ပါသည်။
  - ပါဝင်သော အချက်အလက်များ:
    1. **University Header**: Logo + တက္ကသိုလ် အမည် + Academic Year + **Academic Record** ခေါင်းစဉ်။
    2. **Student Info Table**: ခုံနံပါတ်၊ အမည်၊ ပညာသင်နှစ်၊ Semester၊ ဘွဲ့သင်တန်း (`B.C.Sc.`)၊ အထူးပြုဘာသာ (`Computer Science`)။
    3. **Course Results Table**: No., Course Code, Course Name, Academic Credit Unit, Grade Obtained, Grade Score (4.0 scale), Grade Point (Credit × Grade Score)။
    4. **Totals & GPA Summary**: Total Credit Units, Total Grade Points, Cumulative GPA, Overall GPA။
    5. **Official Grading Scale Grid**: A+ (≥90), A (80-89), A- (75-79), B+ (70-74), B (65-69), B- (60-64), C+ (55-59), C (50-54), D (40-49), F (<40)။
    6. **Issue Date & Signature Block**: ယနေ့ ရက်စွဲနှင့် REGISTRAR လက်မှတ်နေရာ။

---

## 🎓 ၄။ ကျောင်းသား ဘက်ဆိုင်ရာ အသေးစိတ် လုပ်ဆောင်ချက်များ (Student Role Detailed Features)

ကျောင်းသား/သူများအတွက် သီးသန့် ပြုလုပ်ထားသော ရလဒ် ကြည့်ရှုရေး Portal ဖြစ်ပါသည်။

---

### ၄.၁။ လုံခြုံသော အကောင့်သစ် စာရင်းသွင်းခြင်း (Student Registration)
- **ဝင်ခွင့် စိစစ်ခြင်း (Admitted Student Check)**:
  - ကျောင်းသား အကောင့်သစ် ပြုလုပ်ရာတွင် Admin ထည့်သွင်းထားသော **ဝင်ခွင့်ရကျောင်းသား စာရင်း** ရှိ အီးမေးလ် ဖြစ်မှသာ စာရင်းသွင်းခွင့် ပြုပါသည်။
  - စာရင်းမဝင်သော အီးမေးလ် ရိုက်ထည့်ပါက *"ဤအီးမေးလ်သည် ဝင်ခွင့်ရကျောင်းသား စာရင်းတွင် မရှိပါ။ စီမံခန့်ခွဲသူထံ ဆက်သွယ်ပါ။"* ဟု အသိပေးပါသည်။
- **အကောင့် လုံခြုံရေး**: စကားဝှက်အား အနည်းဆုံး ၆ လုံး သတ်မှတ်ရမည်ဖြစ်ပြီး BCrypt ဖြင့် အမှန်တကူ Hash ပြုလုပ် သိမ်းဆည်းပါသည်။

---

### ၄.၂။ ကျောင်းသား ပင်မ ဒက်ရှ်ဘုတ် (Student Dashboard)
- **Hero Welcome Banner Card**:
  - Primary Blue Gradient အလှဆင် ထားပြီး ကျောင်းသား အမည်၊ ခုံနံပါတ်၊ Avatar Initials နှင့် ရလဒ်များဆီ သို့ တိုက်ရိုက်သွားရန် Button။
- **Academic Summary Statistics Cards**:
  - **Overall CGPA**: စုစုပေါင်း ရရှိထားသော CGPA (e.g. `3.85 / 4.0`)။
  - **ပျမ်းမျှ အမှတ် (Average Score)**: စုစုပေါင်း ပျမ်းမျှ ရာခိုင်နှုန်း (e.g. `85.5%`) နှင့် ရရှိသော Grade။
  - **အောင်မြင်သည့် ဘာသာရပ်များ (Passed Subjects)**: အောင်မြင်သော ဘာသာရပ် အရေအတွက် (e.g. `5 / 5` - `100%` အောင်မြင်)။
- **ကိုယ်ရေး အချက်အလက် Card (Profile Info)**:
  - ကျောင်းသား၏ အီးမေးလ်၊ ဖုန်းနံပါတ်၊ ကျား/မ နှင့် စတင် ဝင်ရောက်သည့်နေ့။ (Mobile မိုဘိုင်း ဖုန်းများတွင် အီးမေးလ်နှင့် ဖုန်းနံပါတ်များ ထပ်မသွားစေရန် တိကျစွာ Layout ပြုလုပ်ထားပါသည်)။
- **လတ်တလော စာမေးပွဲ ရလဒ်များ (Recent Results Preview Table)**:
  - လတ်တလော ထွက်ရှိထားသော ဘာသာရပ် ရလဒ် ၅ ခု၏ သင်္ကေတ၊ အမည်၊ ရမှတ်၊ Grade Badge နှင့် အောင်/ကျ Status Pill။

---

### ၄.၃။ အသေးစိတ် ရလဒ်များ ကြည့်ရှုခြင်း (My Exam Results)
- **Semester အလိုက် Accordion View**:
  - ပညာသင်နှစ်နှင့် Semester တစ်ခုစီအောက်တွင် သင်ယူခဲ့ရသော ဘာသာရပ် ရလဒ်များကို စနစ်တကျ ကြည့်ရှုနိုင်ခြင်း။
- ** Grade badges**: Grade အလိုက် အရောင်ကွဲပြားသော Badges များ (`A+` စိမ်း၊ `A` ပြာ၊ `B` ခရမ်း၊ `D/F` နီ) ဖြင့် ကြည့်ရှုရ လွယ်ကူခြင်း။

---

### ၄.၄။ ကျောင်းသား တရားဝင် အမှတ်စာရင်း ထုတ်ယူခြင်း (Student Transcript Print)
- ကျောင်းသားများသည် မိမိတို့၏ **Academic Record** ကို Admin ဘက်တွင် နည်းတူ University Logo၊ Official Table Structure၊ Credit Units၊ Grade Points၊ GPA Summary နှင့် Registrar Signature Block ပါဝင်သော A4 Format ဖြင့် မိမိကိုယ်တိုင် ထုတ်ယူ Print / PDF သိမ်းဆည်းနိုင်ပါသည်။

---

## 📊 ၅။ တက္ကသိုလ် အဆင့်သတ်မှတ်ချက် စံနှုန်းများ (UCS Hpa-an Grading Scale Rules)

| ရာခိုင်နှုန်း Range | Grade | Grade Point (4.0 Scale) | အဓိပ္ပာယ် |
|---|:---:|:---:|---|
| **90% – 100%** | **A+** | **4.00** | Outstanding |
| **80% – 89%** | **A** | **4.00** | Excellent |
| **75% – 79%** | **A-** | **3.75** | Very Good |
| **70% – 74%** | **B+** | **3.50** | Good |
| **65% – 69%** | **B** | **3.00** | Above Average |
| **60% – 64%** | **B-** | **2.75** | Average |
| **55% – 59%** | **C+** | **2.50** | Below Average |
| **50% – 54%** | **C** | **2.00** | Satisfactory (Pass Threshold) |
| **40% – 49%** | **D** | **1.00** | Marginal Pass |
| **0% – 39%** | **F** | **0.00** | Fail |

---

## 🛠️ ၆။ စနစ်အား မောင်းနှင်နည်း လမ်းညွှန် (Deployment & Execution Guide)

### ၁။ Maven Build & Compile ပြုလုပ်ခြင်း
```bash
mvn clean compile
```

### ၂။ Server နှင့် Web Frontend အား စတင် မောင်းနှင်ခြင်း
```bash
cd web-app
mvn exec:java
```

### ၃။ စမ်းသပ် အသုံးပြုနိုင်သော Default အကောင့်များ
- **System Portal URL**: `http://localhost:8080/`
- **Admin Account**: `admin@example.com` / `admin123`
- **Admitted Student Account**: `john.doe@university.edu` / `student123`

---
