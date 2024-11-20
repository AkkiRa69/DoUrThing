import 'package:get/get.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'title': 'TODO List',
          'add': 'Add Task',
          'update': "Update Task",
          'completed': 'Completed',
          'ti': 'Title',
          'des': 'Description',
          'startdate': 'Start Date',
          'duedate': 'Due Date',
          'en_ti': 'Enter task title',
          'en_des': 'Enter task description',
          'en_start': 'Enter start date',
          'en_due': 'Enter due date'
        },
        'km_KH': {
          'title': 'បញ្ជីកិច្ចការ',
          'add': 'បន្ថែមកិច្ចការ',
          'update': 'កែប្រែកិច្ចការ',
          'completed': 'បានបញ្ចប់',
          'ti': 'ចំណងជើង',
          'des': 'ការពិពណ៌នា',
          'startdate': 'ថ្ងៃចាប់ផ្តើម',
          'duedate': 'ថ្ងៃបញ្ចប់',
          'en_ti': 'បញ្ចូលចំណងជើងភារកិច្ច',
          'en_des': 'បញ្ចូលការពិពណ៌នាកិច្ចការ',
          'en_start': 'បញ្ចូលកាលបរិច្ឆេទចាប់ផ្តើម',
          'en_due': 'បញ្ចូលកាលបរិច្ឆេទផុតកំណត់'
        }
      };
}
