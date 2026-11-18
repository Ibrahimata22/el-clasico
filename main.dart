import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const ElClasicoApp());

class ElClasicoApp extends StatelessWidget {
  const ElClasicoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'ملعب الكلاسيكو',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087A43)),
      useMaterial3: true,
      fontFamily: 'Arial',
    ),
    home: const BookingHome(),
  );
}

class BookingHome extends StatefulWidget {
  const BookingHome({super.key});
  @override
  State<BookingHome> createState() => _BookingHomeState();
}

class _BookingHomeState extends State<BookingHome> {
  DateTime selectedDate = DateTime.now();
  final Set<String> booked = {'18:00', '21:00'};
  String? selectedSlot;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final int hourlyPrice = 300;

  final List<String> slots = const [
    '16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00'
  ];

  String formatTime(String t) {
    final p = t.split(':');
    final h = int.parse(p[0]);
    final suffix = h >= 12 ? 'م' : 'ص';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:00 $suffix';
  }

  Future<void> chooseDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('en'),
    );
    if (d != null) setState(() { selectedDate = d; selectedSlot = null; });
  }

  void confirmBooking() {
    if (selectedSlot == null) return;
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('تأكيد الحجز', textAlign: TextAlign.right),
      content: Directionality(textDirection: TextDirection.rtl, child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الاسم: ${nameController.text}'),
          Text('رقم الهاتف: ${phoneController.text}'),
          Text('التاريخ: ${DateFormat('yyyy/MM/dd').format(selectedDate)}'),
          Text('الموعد: ${formatTime(selectedSlot!)}'),
          Text('السعر: $hourlyPrice جنيه'),
          const SizedBox(height: 10),
          const Text('هذه نسخة تجريبية؛ لم يتم تحصيل أي مبلغ إلكترونياً.'),
        ],
      )),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('رجوع')),
        FilledButton(onPressed: () {
          setState(() { booked.add(selectedSlot!); selectedSlot = null; });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تسجيل الحجز التجريبي بنجاح')),
          );
        }, child: const Text('تأكيد تجريبي')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075C35),
        foregroundColor: Colors.white,
        title: const Text('ملعب الكلاسيكو', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.sports_soccer))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF064D2E), Color(0xFF159653)],
                begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
            child: Stack(children: [
              Positioned(left: 18, top: 18, child: Icon(Icons.sports_soccer, size: 90, color: Colors.white.withOpacity(.18))),
              const Positioned(right: 20, top: 25, child: Text('EL CLASICO', style: TextStyle(color: Colors.white70, letterSpacing: 3, fontWeight: FontWeight.bold))),
              const Positioned(right: 20, bottom: 24, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('احجز ملعبك الآن', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('اختار اليوم والساعة المناسبة ليك', style: TextStyle(color: Colors.white70)),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('تفاصيل الملعب', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            const CircleAvatar(backgroundColor: Color(0xFFE0F2E8), child: Icon(Icons.grass, color: Color(0xFF087A43))),
            const SizedBox(width: 12),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ملعب الكلاسيكو', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('ملعب كرة قدم خماسي • الموقع يضاف لاحقاً'),
            ])),
            Text('$hourlyPrice ج / ساعة', style: const TextStyle(color: Color(0xFF087A43), fontWeight: FontWeight.bold)),
          ]))),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('اختار تاريخ الحجز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            OutlinedButton.icon(onPressed: chooseDate, icon: const Icon(Icons.calendar_month), label: Text(DateFormat('yyyy/MM/dd').format(selectedDate))),
          ]),
          const SizedBox(height: 8),
          const Row(children: [
            _Legend(color: Color(0xFF087A43), label: 'متاح'),
            SizedBox(width: 18),
            _Legend(color: Color(0xFFB9C0BB), label: 'محجوز'),
            SizedBox(width: 18),
            _Legend(color: Color(0xFF1565C0), label: 'اختيارك'),
          ]),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: slots.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.7),
            itemBuilder: (_, i) {
              final s = slots[i];
              final isBooked = booked.contains(s);
              final isSelected = selectedSlot == s;
              final color = isBooked ? const Color(0xFFB9C0BB) : isSelected ? const Color(0xFF1565C0) : const Color(0xFF087A43);
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: isBooked ? null : () => setState(() => selectedSlot = s),
                child: Container(
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text('${formatTime(s)}  ${isBooked ? 'محجوز' : isSelected ? 'تم الاختيار' : 'متاح'}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('بيانات الحجز', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: nameController, onChanged: (_) => setState(() {}), textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'الاسم بالكامل', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: phoneController, onChanged: (_) => setState(() {}), keyboardType: TextInputType.phone, textDirection: TextDirection.rtl, decoration: const InputDecoration(labelText: 'رقم الموبايل', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder())),
          const SizedBox(height: 12),
          if (selectedSlot != null)
            Card(color: const Color(0xFFE6F4EC), child: Padding(padding: const EdgeInsets.all(14), child: Text('ملخص الحجز: ${formatTime(selectedSlot!)} • $hourlyPrice جنيه', style: const TextStyle(fontWeight: FontWeight.bold)))),
          FilledButton.icon(
            onPressed: selectedSlot == null || nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty ? null : confirmBooking,
            icon: const Icon(Icons.check_circle), label: const Padding(padding: EdgeInsets.all(12), child: Text('تأكيد الحجز', style: TextStyle(fontSize: 17))),
          ),
          const SizedBox(height: 10),
          const Text('تنبيه: المواعيد والأسعار المعروضة بيانات تجريبية قابلة للتعديل من لوحة الإدارة عند استكمال الربط.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      )),
    ),
  );
}

class _Legend extends StatelessWidget {
  final Color color; final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 12)),
  ]);
}
