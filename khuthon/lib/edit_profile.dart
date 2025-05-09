import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cropController = TextEditingController();

  String gender = '';
  String year = '2000';
  String month = '1';
  String day = '1';

  String mbti1 = '';
  String mbti2 = '';
  String mbti3 = '';
  String mbti4 = '';

  String get fullMBTI => mbti1 + mbti2 + mbti3 + mbti4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7EEC6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7EEC6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('프로필 수정', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 80, color: Colors.green),
            const SizedBox(height: 8),
            const Text('프로필 수정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            buildField('닉네임', nameController),
            const SizedBox(height: 16),
            buildGender(),
            const SizedBox(height: 16),
            buildBirthdate(),
            const SizedBox(height: 16),
            buildField('주소', addressController),
            const SizedBox(height: 16),
            buildMBTI(),
            const SizedBox(height: 16),
            buildField('선호 농작물', cropController),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print("닉네임: ${nameController.text}, MBTI: $fullMBTI");
                // TODO: 저장 처리
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[200],
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.green[100],
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        choiceChip('남성', gender, (v) => gender = v),
        const SizedBox(width: 10),
        choiceChip('여성', gender, (v) => gender = v),
      ],
    );
  }

  Widget buildBirthdate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        dropdown(year, List.generate(100, (i) => (1925 + i).toString()),
            (v) => setState(() => year = v)),
        dropdown(month, List.generate(12, (i) => (i + 1).toString()),
            (v) => setState(() => month = v)),
        dropdown(day, List.generate(31, (i) => (i + 1).toString()),
            (v) => setState(() => day = v)),
      ],
    );
  }

  Widget buildMBTI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MBTI'),
        Wrap(
          spacing: 6,
          children: ['E', 'I']
              .map((e) => choiceChip(e, mbti1, (v) => mbti1 = v))
              .toList(),
        ),
        Wrap(
          spacing: 6,
          children: ['N', 'S']
              .map((e) => choiceChip(e, mbti2, (v) => mbti2 = v))
              .toList(),
        ),
        Wrap(
          spacing: 6,
          children: ['F', 'T']
              .map((e) => choiceChip(e, mbti3, (v) => mbti3 = v))
              .toList(),
        ),
        Wrap(
          spacing: 6,
          children: ['P', 'J']
              .map((e) => choiceChip(e, mbti4, (v) => mbti4 = v))
              .toList(),
        ),
      ],
    );
  }

  Widget choiceChip(
      String label, String groupValue, void Function(String) onSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: groupValue == label,
      onSelected: (_) => setState(() => onSelected(label)),
    );
  }

  Widget dropdown(
      String value, List<String> items, ValueChanged<String> onChanged) {
    return DropdownButton<String>(
      value: items.contains(value) ? value : null,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
