import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '教師資訊',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

// 登入頁面
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登入頁面'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 點擊後導航到主頁
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text('以學生身份登入'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 點擊後導航到教師登入頁
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherMainPage()),
                );
              },
              child: Text('以教師身份登入'),
            ),
          ],
        ),
      ),
    );
  }
}

// 教師首頁
class TeacherMainPage extends StatefulWidget {
  @override
  _TeacherMainPageState createState() => _TeacherMainPageState();
}

class _TeacherMainPageState extends State<TeacherMainPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    TeacherHomePage(),
    ActivitiesPage(),
    ChatPage(),
    ClassesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 'logout':
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('教師首頁'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('個人頁面'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('登出'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: '活動',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '聊天室',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '上課',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  String searchQuery = '';

  final List<Map<String, String>> students = [
    {'name': '學生A', 'subject': '數學', 'years': '1年', 'avatarUrl': 'https://via.placeholder.com/150'},
    {'name': '學生B', 'subject': '英文', 'years': '2年', 'avatarUrl': 'https://via.placeholder.com/150'},
    {'name': '學生C', 'subject': '物理', 'years': '3年', 'avatarUrl': 'https://via.placeholder.com/150'},
    {'name': '學生D', 'subject': '化學', 'years': '4年', 'avatarUrl': 'https://via.placeholder.com/150'},
  ];

  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    filteredStudents = students;
  }

  void filterStudents() {
    setState(() {
      filteredStudents = students.where((student) {
        final nameMatch = student['name']!.toLowerCase().contains(searchQuery.toLowerCase());
        return nameMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: '搜尋...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          onChanged: (value) {
            searchQuery = value;
            filterStudents();
          },
        ),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDropdownButton(
                  currentValue: null,
                  hintText: '科目',
                  items: ['數學', '英文', '物理', '化學'],
                  onChanged: (value) => setState(() {
                    // Add your filtering logic here
                  }),
                ),
                _buildDropdownButton(
                  currentValue: null,
                  hintText: '年資',
                  items: ['1年', '2年', '3年', '4年'],
                  onChanged: (value) => setState(() {
                    // Add your filtering logic here
                  }),
                ),
                _buildDropdownButton(
                  currentValue: null,
                  hintText: '時段',
                  items: ['上午', '下午', '晚上'],
                  onChanged: (value) => setState(() {
                    // Add your filtering logic here
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return Card(
                  color: Color.fromARGB(255, 243, 243, 251),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(student['avatarUrl']!),
                          radius: 30,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('科目: ${student['subject']}'),
                            Text('年資: ${student['years']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String? currentValue,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: currentValue,
      hint: Text(hintText),
      icon: Icon(Icons.arrow_drop_down),
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// 教師數據模型
class Teacher {
  final String name;
  final String avatarUrl;
  final String education;
  final String subject;
  final String schedule;
  final String teachingPhilosophy;
  final String certifications;
  final String studentId;
  final String additionalInfo;
  final String teachingVideoUrl;
  final double fee;

  Teacher({
    required this.name,
    required this.avatarUrl,
    required this.education,
    required this.subject,
    required this.schedule,
    required this.teachingPhilosophy,
    required this.certifications,
    required this.studentId,
    required this.additionalInfo,
    required this.teachingVideoUrl,
    required this.fee,
  });
}

// 主要頁面，包含底部導航欄
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    CustomerPage(),
    DiscussionPage(),
    TeacherPage(),
    NotesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 'logout':
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首頁'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('個人頁面'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('登出'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '討論區',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '教師',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: '筆記',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// 顧客的頁面
class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  // 模擬教師數據
  final Map<String, Teacher> allTeachers = {
    '1': Teacher(
      name: 'John Doe',
      avatarUrl: 'https://via.placeholder.com/150',
      education: '國立台灣大學 數學博士',
      subject: '數學',
      schedule: '週一至週五 9am-5pm',
      teachingPhilosophy: '讓數學變得有趣且易於理解。',
      certifications: '數學教師認證',
      studentId: '123456',
      additionalInfo: '台中 10年',
      teachingVideoUrl: 'https://via.placeholder.com/150',
      fee: 350.0,
    ),
    '2': Teacher(
      name: 'Jane Smith',
      avatarUrl: 'https://via.placeholder.com/150',
      education: '國立台灣大學 物理碩士',
      subject: '物理',
      schedule: '週一至週五 10am-4pm',
      teachingPhilosophy: '實踐學習是最好的方法。',
      certifications: '物理教師認證',
      studentId: '654321',
      additionalInfo: '台北 8年',
      teachingVideoUrl: 'https://via.placeholder.com/150',
      fee: 250.0,
    ),
    '3': Teacher(
      name: 'Sam Johnson',
      avatarUrl: 'https://via.placeholder.com/150',
      education: '國立台灣大學 化學碩士',
      subject: '化學',
      schedule: '週一至週五 1pm-7pm',
      teachingPhilosophy: '將化學與實際應用相結合。',
      certifications: '化學教師認證',
      studentId: '789012',
      additionalInfo: '台中 12年',
      teachingVideoUrl: 'https://via.placeholder.com/150',
      fee: 450.0,
    ),
  };

  Map<String, Teacher> filteredTeachers = {};

  String? selectedRegion;
  String? selectedSubject;
  String? selectedYears;
  String? selectedFee;
  String? selectedDay;
  String? selectedTime;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTeachers = Map.from(allTeachers);
  }

  void filterTeachers() {
    setState(() {
      filteredTeachers = Map.fromEntries(
        allTeachers.entries.where((entry) {
          final teacher = entry.value;
          final regionMatch = selectedRegion == null || selectedRegion == '地區' || teacher.additionalInfo.contains(selectedRegion!);
          final subjectMatch = selectedSubject == null || selectedSubject == '科目' || teacher.subject == selectedSubject;
          final yearsMatch = selectedYears == null || selectedYears == '年資' || _yearsFilter(teacher, selectedYears!);
          final feeMatch = selectedFee == null || selectedFee == '收費/小時' || _feeFilter(teacher, selectedFee!);
          final dayMatch = selectedDay == null || selectedDay == '星期' || teacher.schedule.contains(selectedDay!);
          final timeMatch = selectedTime == null || selectedTime == '時段' || teacher.schedule.contains(selectedTime!);
          final searchMatch = teacher.name.toLowerCase().contains(searchQuery.toLowerCase()) || teacher.subject.toLowerCase().contains(searchQuery.toLowerCase());
          return regionMatch && subjectMatch && yearsMatch && feeMatch && dayMatch && timeMatch && searchMatch;
        }),
      );
    });
  }

  bool _yearsFilter(Teacher teacher, String filter) {
    if (filter == '1年') {
      return teacher.additionalInfo.contains('1年');
    } else if (filter == '2~3年') {
      return teacher.additionalInfo.contains('2年') || teacher.additionalInfo.contains('3年');
    } else if (filter == '4~5年') {
      return teacher.additionalInfo.contains('4年') || teacher.additionalInfo.contains('5年');
    } else if (filter == '5年以上') {
      int years = int.parse(teacher.additionalInfo.split(' ')[1].replaceAll('年', ''));
      return years > 5;
    }
    return true;
  }

  bool _feeFilter(Teacher teacher, String filter) {
    final fee = teacher.fee;
    switch (filter) {
      case '200以下':
        return fee < 200;
      case '200~400':
        return fee >= 200 && fee <= 400;
      case '400~600':
        return fee > 400 && fee <= 600;
      case '600以上':
        return fee > 600;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: '搜尋...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          onChanged: (value) {
            searchQuery = value;
            filterTeachers();
          },
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Column(
        children: [
          FilterBar(
            selectedRegion: selectedRegion,
            selectedSubject: selectedSubject,
            selectedYears: selectedYears,
            selectedFee: selectedFee,
            selectedDay: selectedDay,
            selectedTime: selectedTime,
            onFilterChanged: (region, subject, years, fee, day, time) {
              selectedRegion = region;
              selectedSubject = subject;
              selectedYears = years;
              selectedFee = fee;
              selectedDay = day;
              selectedTime = time;
              filterTeachers();
            },
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: filteredTeachers.length,
              itemBuilder: (context, index) {
                final teacherID = filteredTeachers.keys.elementAt(index);
                final teacher = filteredTeachers[teacherID]!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherDetailPage(teacher: teacher),
                      ),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255, 243, 243, 251),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(teacher.avatarUrl),
                            radius: 30,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teacher.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('科目: ${teacher.subject}'),
                              Text('學歷: ${teacher.education}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  final String? selectedRegion;
  final String? selectedSubject;
  final String? selectedYears;
  final String? selectedFee;
  final String? selectedDay;
  final String? selectedTime;
  final void Function(
    String? region,
    String? subject,
    String? years,
    String? fee,
    String? day,
    String? time,
  ) onFilterChanged;

  FilterBar({
    required this.selectedRegion,
    required this.selectedSubject,
    required this.selectedYears,
    required this.selectedFee,
    required this.selectedDay,
    required this.selectedTime,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.blueGrey[50], // 設置背景顏色
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildDropdownButton<String>(
              currentValue: selectedRegion,
              hintText: '地區',
              items: ['地區', '台中', '台北'],
              onChanged: (value) => onFilterChanged(
                value,
                selectedSubject,
                selectedYears,
                selectedFee,
                selectedDay,
                selectedTime,
              ),
            ),
            _buildDropdownButton<String>(
              currentValue: selectedSubject,
              hintText: '科目',
              items: ['科目', '國文', '英文', '數學', '物理', '化學', '生物', '公民', '歷史'],
              onChanged: (value) => onFilterChanged(
                selectedRegion,
                value,
                selectedYears,
                selectedFee,
                selectedDay,
                selectedTime,
              ),
            ),
            _buildDropdownButton<String>(
              currentValue: selectedYears,
              hintText: '年資',
              items: ['年資', '1年', '2~3年', '4~5年', '5年以上'],
              onChanged: (value) => onFilterChanged(
                selectedRegion,
                selectedSubject,
                value,
                selectedFee,
                selectedDay,
                selectedTime,
              ),
            ),
            _buildDropdownButton<String>(
              currentValue: selectedFee,
              hintText: '收費/小時',
              items: ['收費/小時', '200以下', '200~400', '400~600', '600以上'],
              onChanged: (value) => onFilterChanged(
                selectedRegion,
                selectedSubject,
                selectedYears,
                value,
                selectedDay,
                selectedTime,
              ),
            ),
            _buildDropdownButton<String>(
              currentValue: selectedDay,
              hintText: '星期',
              items: ['星期', '一', '二', '三', '四', '五', '六', '日'],
              onChanged: (value) => onFilterChanged(
                selectedRegion,
                selectedSubject,
                selectedYears,
                selectedFee,
                value,
                selectedTime,
              ),
            ),
            _buildDropdownButton<String>(
              currentValue: selectedTime,
              hintText: '時段',
              items: ['時段', '8~9 am', '9~10 am', '10~11 am', '11~12 am', '1~2 pm', '2~3 pm', '3~4 pm', '4~5 pm', '5~6 pm', '6~7 pm', '7~8 pm', '8~9 pm'],
              onChanged: (value) => onFilterChanged(
                selectedRegion,
                selectedSubject,
                selectedYears,
                selectedFee,
                selectedDay,
                value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton<T>({
    required T? currentValue,
    required String hintText,
    required List<T> items,
    required void Function(T? newValue) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 10), // 設置右側間距
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // 圓角邊框
        border: Border.all(color: Colors.blueGrey, width: 0.8), // 邊框顏色和寬度
      ),
      padding: EdgeInsets.symmetric(horizontal: 10), // 內邊距
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: currentValue,
          hint: Text(hintText, style: TextStyle(color: Colors.blueGrey[800])),
          icon: Icon(Icons.arrow_drop_down, color: Colors.blueGrey[700]),
          items: items.map((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(value.toString(), style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(color: Colors.black, fontSize: 16), // 文字樣式
          dropdownColor: Colors.white, // 下拉菜單背景顏色
        ),
      ),
    );
  }
}

// 教師詳情頁
class TeacherDetailPage extends StatelessWidget {
  final Teacher teacher;

  TeacherDetailPage({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${teacher.name} - 詳情'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(teacher.avatarUrl),
                    radius: 40,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('學歷: ${teacher.education}'),
                      Text('科目: ${teacher.subject}'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              Text(
                '內容:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('費用: \$${teacher.fee}/小時', style: TextStyle(fontSize: 16)),
              Text('行事曆: ${teacher.schedule}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Divider(),
              Text(
                '教學理念:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(teacher.teachingPhilosophy, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Divider(),
              Text(
                '證照證書:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(teacher.certifications, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Divider(),
              Text(
                '學生證及其他加分內容:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('學生證: ${teacher.studentId}', style: TextStyle(fontSize: 16)),
              Text('其他加分內容: ${teacher.additionalInfo}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Divider(),
              Text(
                '1分鐘教學影片:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.play_circle_outline, size: 50, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 添加預約行為或導航至預約頁面
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('預約成功！')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 108, 125, 255),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('預約'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 討論區頁面
class DiscussionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('討論區'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到討論區！'),
      ),
    );
  }
}

// 教師頁面
class TeacherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('教師'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到教師頁面！'),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

// 筆記頁面
class _NotesPageState extends State<NotesPage> {
  String? selectedSubject;
  String? selectedTerm;
  String? selectedPrice;

  final List<Map<String, String>> notes = [
    {'title': '筆記 1', 'image': 'https://via.placeholder.com/200', 'subject': '數學', 'term': '上學期', 'price': '100'},
    {'title': '筆記 2', 'image': 'https://via.placeholder.com/200', 'subject': '英文', 'term': '下學期', 'price': '150'},
    {'title': '筆記 3', 'image': 'https://via.placeholder.com/200', 'subject': '物理', 'term': '上學期', 'price': '200'},
    {'title': '筆記 4', 'image': 'https://via.placeholder.com/200', 'subject': '化學', 'term': '下學期', 'price': '250'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('筆記'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: Add settings functionality
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDropdownButton(
                  currentValue: selectedSubject,
                  hintText: '科目',
                  items: ['數學', '英文', '物理', '化學'],
                  onChanged: (value) => setState(() => selectedSubject = value),
                ),
                _buildDropdownButton(
                  currentValue: selectedTerm,
                  hintText: '學期',
                  items: ['上學期', '下學期'],
                  onChanged: (value) => setState(() => selectedTerm = value),
                ),
                _buildDropdownButton(
                  currentValue: selectedPrice,
                  hintText: '價格',
                  items: ['100', '150', '200', '250'],
                  onChanged: (value) => setState(() => selectedPrice = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  color: Color.fromARGB(255, 243, 243, 251),
                  child: Column(
                    children: [
                      Image.network(note['image']!),
                      SizedBox(height: 8),
                      Text(
                        note['title']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('科目: ${note['subject']}'),
                      Text('學期: ${note['term']}'),
                      Text('價格: ${note['price']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String? currentValue,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: currentValue,
      hint: Text(hintText),
      icon: Icon(Icons.arrow_drop_down),
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// 個人頁面
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('個人頁面'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到個人頁面！'),
      ),
    );
  }
}

// 活動頁面
class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('活動'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到活動頁面！'),
      ),
    );
  }
}

// 聊天頁面
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天室'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到聊天室頁面！'),
      ),
    );
  }
}

// 上課頁面
class ClassesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上課'),
        backgroundColor: Color.fromARGB(255, 108, 125, 255),
      ),
      body: Center(
        child: Text('歡迎來到上課頁面！'),
      ),
    );
  }
}
