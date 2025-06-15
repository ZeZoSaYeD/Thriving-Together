import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'diagnoses_page.dart';

// Define ExerciseStep class (adjust based on your actual model)
class ExerciseStep {
  final String content;
  ExerciseStep({required this.content});
}

class CognitionExercises extends StatefulWidget {
  const CognitionExercises({super.key});

  @override
  State<CognitionExercises> createState() => _CognitionExercisesState();
}

class _CognitionExercisesState extends State<CognitionExercises> {
  int currentExerciseIndex = 0;
  int score = 0;
  bool showFeedback = false;
  bool isCorrect = false;
  String feedbackMessage = '';
  TextEditingController textAnswerController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<int> sequenceOrder = []; // For sequence exercises

  final List<Map<String, dynamic>> exercises = [
    {
      'type': 'audio_choice',
      'question': 'استمع للصوت وحدد الحرف',
      'audio': 'sounds/letter_a.m4a',
      'options': ['أ', 'ب', 'ت', 'ث'],
      'answer': 'أ',
    },
    {
      'type': 'image_choice',
      'question': 'ما هو الحرف الأول في اسم هذه الصورة؟',
      'image': 'assets/images/apple.png',
      'options': ['ف', 'ل', 'م', 'ت'],
      'answer': 'ت',
    },
    {
      'type': 'text_input',
      'question': 'كوّن كلمة من الحروف التالية: م - ل - ق',
      'answer': 'قلم',
    },
    {
      'type': 'audio_initial_choice',
      'question': 'استمع للكلمة وحدد الصوت الذي تسمعه في البداية',
      'audio': 'sounds/car.m4a',
      'options': ['ع', 'ك', 'س', 'م'],
      'answer': 'س',
    },
    {
      'type': 'shape_choice',
      'question': 'اختر الشكل الصحيح',
      'image': 'assets/images/circle.jpeg',
      'options': ['مربع', 'دائرة', 'مثلث', 'مستطيل'],
      'answer': 'دائرة',
    },
    {
      'type': 'word_choice',
      'question': 'اختر الكلمة التي تختلف عن البقية',
      'options': ['قلم', 'كتاب', 'قميص', 'دفتر'],
      'answer': 'قميص',
    },
    {
      'type': 'sequence',
      'question': 'رتب الصور حسب التسلسل الصحيح',
      'images': [
        'assets/images/step1.jpg',
        'assets/images/step2.jpg',
        'assets/images/step3.jpg',
      ],
      'answer': [0, 1, 2],
    },
    {
      'type': 'sentence_completion',
      'question': 'ذهبت إلى المدرسة بـ _____',
      'options': ['سيارة', 'بيت', 'قلم', 'كتاب'],
      'answer': 'سيارة',
    },
    {
      'type': 'letter_match',
      'question': 'اختر الحرف الذي يشبه الحرف المعروض: ب',
      'options': ['ب', 'ت', 'د', 'س'],
      'answer': 'ب',
    },
    {
      'type': 'word_image_match',
      'question': 'اقرأ الكلمة واختر الصورة المناسبة: سيارة',
      'images': [
        'assets/images/car.jpg',
        'assets/images/house.jpg',
        'assets/images/book.png',
        'assets/images/apple.png',
      ],
      'answer': 0,
    },
    {
      'type': 'image_description',
      'question': 'اختر الجملة التي تصف الصورة بشكل صحيح',
      'image': 'assets/images/cooking.jpg',
      'options': ['الطفل يأكل', 'الطفل يلعب', 'الطفل ينام', 'الطفل يجري'],
      'answer': 'الطفل يأكل',
    },
    {
      'type': 'sentence_formation',
      'question': 'كوّن جملة صحيحة من الكلمات التالية: المدرسة، يذهب، كل يوم، محمد',
      'answer': 'محمد يذهب كل يوم المدرسة',
    },
    {
      'type': 'letter_count',
      'question': 'كم عدد الاحرف في كلمة "كتاب"؟',
      'options': ['خمسة', 'أربعة', 'ثلاثة', 'اثنين'],
      'answer': 'خمسة',
    },
    {
      'type': 'image_initial',
      'question': 'ما هو الحرف الذي يبدأ به اسم هذه الصورة؟',
      'image': 'assets/images/sun.jpg',
      'options': ['ص', 'ش', 'س', 'د'],
      'answer': 'ش',
    },
    {
      'type': 'audio_letter',
      'question': 'استمع للحرف واختر الحرف الصحيح',
      'audio': 'sounds/letter_q.m4a',
      'options': ['ق', 'ف', 'ك', 'ع'],
      'answer': 'ق',
    },
    {
      'type': 'color_choice',
      'question': 'اختر لون التفاحة',
      'image': 'assets/images/apple.png',
      'options': ['أحمر', 'أصفر', 'أبيض', 'أزرق'],
      'answer': 'أحمر',
    },
    {
      'type': 'counting',
      'question': 'كم عدد التفاحات في الصورة؟',
      'image': 'assets/images/ten apples.webp',
      'options': ['5', '8', '10', '12'],
      'answer': '10',
    },
    {
      'type': 'true_false',
      'question': 'هل هذه صورة لشجرة؟',
      'image': 'assets/images/tree.jpeg',
      'options': ['نعم', 'لا'],
      'answer': 'نعم',
    },
    {
      'type': 'true_false',
      'question': 'الحيوانات تعيش في الغابة.',
      'options': ['صح', 'خطأ'],
      'answer': 'صح',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      // Handle audio completion if needed
    });
  }

  @override
  void dispose() {
    textAnswerController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio(String audioPath) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      debugPrint('Audio error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تشغيل الصوت: ${e.toString()}')),
        );
      }
    }
  }

  void checkAnswer(dynamic selectedAnswer) {
    final currentExercise = exercises[currentExerciseIndex];
    final correctAnswer = currentExercise['answer'];
    bool correct = false;

    if (currentExercise['type'] == 'text_input' ||
        currentExercise['type'] == 'sentence_formation') {
      correct = textAnswerController.text.trim() == correctAnswer;
    } else if (currentExercise['type'] == 'sequence') {
      correct = selectedAnswer.toString() == correctAnswer.toString();
    } else if (currentExercise['type'] == 'word_image_match') {
      correct = selectedAnswer == correctAnswer;
    } else {
      correct = selectedAnswer == correctAnswer;
    }

    setState(() {
      isCorrect = correct;
      showFeedback = true;
      feedbackMessage = correct
          ? AppLocalizations.of(context)?.correctAnswer ?? 'إجابة صحيحة!'
          : '${AppLocalizations.of(context)?.wrongAnswer ?? 'خطأ!'} الإجابة الصحيحة: $correctAnswer';
      if (correct) score++;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (currentExerciseIndex < exercises.length - 1) {
        nextExercise();
      } else {
        // Test completed - show results
        showCompletionDialog();
      }
    });
  }

  void nextExercise() {
    setState(() {
      currentExerciseIndex++;
      showFeedback = false;
      textAnswerController.clear();
      // Reset sequence order for sequence exercises
      if (exercises[currentExerciseIndex]['type'] == 'sequence') {
        sequenceOrder = List.generate(
            exercises[currentExerciseIndex]['images'].length,
                (index) => index
        );
      }
    });
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.congratulations ?? 'تهانينا!'),
          content: Text(
            '${AppLocalizations.of(context)?.completedExercises ?? 'لقد أكملت جميع التمارين بنجاح!'}\n'
                '${AppLocalizations.of(context)?.score ?? 'نتيجتك'}: $score/${exercises.length}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: Text(AppLocalizations.of(context)?.done ?? 'تم'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExerciseContent(Map<String, dynamic> exercise) {
    switch (exercise['type']) {
      case 'audio_choice':
      case 'audio_initial_choice':
      case 'audio_letter':
        return _buildAudioExercise(exercise);
      case 'image_choice':
      case 'shape_choice':
      case 'image_description':
      case 'image_initial':
      case 'color_choice':
      case 'counting':
      case 'true_false' when exercise.containsKey('image'):
        return _buildImageBasedExercise(exercise);
      case 'text_input':
      case 'sentence_formation':
        return _buildTextInputExercise(exercise);
      case 'word_choice':
      case 'sentence_completion':
      case 'letter_match':
      case 'letter_count':
      case 'true_false':
        return _buildOptionsExercise(exercise);
      case 'sequence':
        return _buildSequenceExercise(exercise);
      case 'word_image_match':
        return _buildWordImageMatchExercise(exercise);
      default:
        return Text('نوع التمرين غير معروف: ${exercise['type']}');
    }
  }

  Widget _buildAudioExercise(Map<String, dynamic> exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => playAudio(exercise['audio']),
          child: Text(AppLocalizations.of(context)?.playAudio ?? 'تشغيل الصوت'),
        ),
        const SizedBox(height: 20),
        _buildOptions(exercise['options']),
      ],
    );
  }

  Widget _buildImageBasedExercise(Map<String, dynamic> exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (exercise.containsKey('image'))
          Image.asset(
            exercise['image'],
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              color: Colors.grey[200],
              child: Center(child: Text('صورة غير متوفرة')),
            ),
          ),
        const SizedBox(height: 20),
        if (exercise.containsKey('options'))
          _buildOptions(exercise['options']),
      ],
    );
  }

  Widget _buildTextInputExercise(Map<String, dynamic> exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: textAnswerController,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.all(10),
            hintText: AppLocalizations.of(context)?.enterAnswer ?? 'أدخل إجابتك',
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: showFeedback ? null : () => checkAnswer(textAnswerController.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(AppLocalizations.of(context)?.check ?? 'تحقق'),
        ),
      ],
    );
  }

  Widget _buildOptionsExercise(Map<String, dynamic> exercise) {
    return _buildOptions(exercise['options']);
  }

  Widget _buildOptions(List<dynamic> options) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: options.map((option) {
        return ElevatedButton(
          onPressed: showFeedback ? null : () => checkAnswer(option),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEEEEEE),
            foregroundColor: const Color(0xFF555555),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            elevation: 1,
          ),
          child: Text(option.toString(), style: const TextStyle(fontSize: 16)),
        );
      }).toList(),
    );
  }

  Widget _buildSequenceExercise(Map<String, dynamic> exercise) {
    if (sequenceOrder.isEmpty) {
      sequenceOrder = List.generate(exercise['images'].length, (index) => index);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = sequenceOrder.removeAt(oldIndex);
              sequenceOrder.insert(newIndex, item);
            });
          },
          children: sequenceOrder.map((index) {
            return ListTile(
              key: Key('$index'),
              contentPadding: EdgeInsets.zero,
              title: Image.asset(
                exercise['images'][index],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey[200],
                  child: Center(child: Text('صورة غير متوفرة')),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: showFeedback ? null : () => checkAnswer(sequenceOrder),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(AppLocalizations.of(context)?.check ?? 'تحقق'),
        ),
      ],
    );
  }

  Widget _buildWordImageMatchExercise(Map<String, dynamic> exercise) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: (exercise['images'] as List<String>).asMap().entries.map((entry) {
        int index = entry.key;
        String image = entry.value;
        return GestureDetector(
          onTap: showFeedback ? null : () => checkAnswer(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: Colors.grey[200],
                child: Center(child: Text('صورة غير متوفرة')),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = exercises[currentExerciseIndex];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.cognitionExercises ?? 'تمارين الإدراك'),
          centerTitle: true,
          backgroundColor: const Color(0xFF4070F4),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              LinearProgressIndicator(
                value: (currentExerciseIndex + 1) / exercises.length,
                backgroundColor: const Color(0xFFDDDDDD),
                color: const Color(0xFF4A90E2),
                minHeight: 20,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 20),

              // Exercise content
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2C5DAB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question
                    Text(
                      currentExercise['question'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF56806),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Exercise content
                    _buildExerciseContent(currentExercise),

                    const SizedBox(height: 20),

                    // Feedback
                    if (showFeedback)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isCorrect
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          feedbackMessage,
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}