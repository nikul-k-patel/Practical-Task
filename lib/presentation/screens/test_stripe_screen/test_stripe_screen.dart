import 'package:demo/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestStripScreen extends StatefulWidget {
  const TestStripScreen({super.key});

  @override
  _TestStripScreenState createState() => _TestStripScreenState();
}

class _TestStripScreenState extends State<TestStripScreen> {
  List<String> parameters = [
    "Total Hardness (ppm)",
    "Total Chlorine (ppm)",
    "Free Chlorine (ppm)",
    "pH (ppm)",
    "Total Alkalinity (ppm)",
    "Cyanuric Acid (ppm)",
  ];

  List<List<Color>> colorOptions = [
    [Color(0xFF0000FF), Color(0xFF00BFFF), Color(0xFF800080), Color(0xFFFF00FF), Color(0xFFFF0000)],
    [Color(0xFFFFFF00), Color(0xFFADFF2F), Color(0xFF00FF00), Color(0xFF008080), Color(0xFF0000FF)],
    [Color(0xFFFFFF00), Color(0xFFADFF2F), Color(0xFF00FF00), Color(0xFF008080), Color(0xFF0000FF)],
    [Color(0xFFFF6347), Color(0xFFFFA500), Color(0xFFFF4500), Color(0xFFFF0000), Color(0xFFFF4500)],
    [Color(0xFFFFFF99), Color(0xFFFFFF00), Color(0xFFADFF2F), Color(0xFF00FF00), Color(0xFF008080)],
    [Color(0xFFFF0000), Color(0xFFFF4500), Color(0xFFFF69B4), Color(0xFF800080), Color(0xFF4B0082)],
  ];

  List<List<dynamic>> values = [
    [0, 110, 250, 500, 1000],
    [0, 1, 3, 5, 10],
    [0, 1, 3, 5, 10],
    [6, 6.8, 7.2, 7.8, 8.4],
    [0, 40, 120, 180, 240],
    [0, 50, 100, 150, 300],
  ];

  List<int> selectedIndices = List.filled(6, 0);
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    super.dispose();
  }

  void updateColor(int index, String value) {
    int intValue;
    try {
      intValue = int.parse(value);
    } catch (e) {
      intValue = -1;
    }

    if (values[index].contains(intValue)) {
      setState(() {
        selectedIndices[index] = values[index].indexOf(intValue);
      });
    } else {
      showError(message: "Value does not match any color option");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Test Strip',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: parameters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 17),
                              child: Container(
                                width: 18,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: colorOptions[index][selectedIndices[index]],
                                    borderRadius: BorderRadius.circular(4),
                                ),

                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          parameters[index],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: SizedBox(
                                          width: 60,
                                          height: 32,
                                          child: TextField(
                                            controller: controllers[index],
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.7),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                              hintText: '${values[index][selectedIndices[index]]}',
                                              border: const OutlineInputBorder(),
                                              focusedBorder: const OutlineInputBorder(),
                                            ),
                                            onSubmitted: (value) {
                                              updateColor(index, value);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: colorOptions[index].map((color) {
                                      int colorIndex = colorOptions[index].indexOf(color);
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndices[index] = colorIndex;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 16,

                                              decoration: BoxDecoration(
                                                  color: color,
                                                borderRadius: BorderRadius.circular(4)
                                              ),
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                            ),
                                            Text(
                                              '${values[index][colorIndex]}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
