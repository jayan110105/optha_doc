import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientDetailsCard extends StatefulWidget {
  final Map<String, dynamic>? selectedRecord;
  final bool isEditing;

  const PatientDetailsCard({
    super.key,
    this.selectedRecord,
    required this.isEditing,
  });

  @override
  State<PatientDetailsCard> createState() => _PatientDetailsCardState();
}

class _PatientDetailsCardState extends State<PatientDetailsCard> {
  late TextEditingController nameController;
  late TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.selectedRecord?['name'] ?? '');
    ageController = TextEditingController(text: widget.selectedRecord?['age']?.toString() ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required TextInputType inputType,
    double? width,
    TextStyle? textStyle,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(color: Color(0xFF163351).withValues(alpha: 0.3), width: 2),
          ),
        ),
        style: textStyle ?? const TextStyle(
          fontSize: 16,
          color: Color(0xFF163351),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required Widget content}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Color(0xFF163351).withValues(alpha: .6),
        ),
        const SizedBox(width: 8),
        content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF163351),
            child: Text(
              widget.selectedRecord?['name'][0] ?? '',
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          widget.isEditing
              ? buildInputField(
            controller: nameController,
            hint: 'Enter name',
            inputType: TextInputType.text,
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
          )
              : Text(
            widget.selectedRecord?['name'] ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF163351),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.person,
                    content: Row(
                      children: [
                        Text(
                          'Age: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF163351).withValues(alpha: .6),
                          ),
                        ),
                        widget.isEditing
                            ? buildInputField(
                          controller: ageController,
                          hint: 'Enter age',
                          inputType: TextInputType.number,
                          width: 60,
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF163351).withValues(alpha: .6),
                          ),
                        )
                            : Text(
                          '${widget.selectedRecord?['age']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF163351).withValues(alpha: .6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildDetailItem(
                    icon: Icons.text_snippet,
                    content: Text(
                      'ID: ${widget.selectedRecord?['patientId']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351).withValues(alpha: .6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    content: Text(
                      'Last Exam: ${widget.selectedRecord?['createdAt'] != null ? DateFormat('MMM d, yyyy').format(widget.selectedRecord!['createdAt']) : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351).withValues(alpha: .6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailItem(
                    icon: Icons.access_time,
                    content: Text(
                      widget.selectedRecord?['createdAt'] != null
                          ? DateFormat('h:mm a').format(widget.selectedRecord!['createdAt'])
                          : '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF163351).withValues(alpha: .6),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
