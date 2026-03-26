import 'package:flutter/material.dart';
import 'package:grit/features/trainer/data/models/exercise_model.dart';
import 'package:grit/features/trainer/view/programs/widgets/exercise_list_item.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/constants/text_styles.dart';

class ExerciseLibrarySheet extends StatefulWidget {
  final List<ExerciseModel> initialAdded;
  final ValueChanged<List<ExerciseModel>> onDone;
  final List<Map<String, dynamic>> exercises;
  final List<String>? injuryKeywords;

  const ExerciseLibrarySheet({
    super.key,
    required this.initialAdded,
    required this.onDone,
    required this.exercises,
    this.injuryKeywords,
  });

  @override
  State<ExerciseLibrarySheet> createState() => _ExerciseLibrarySheetState();
}

class _ExerciseLibrarySheetState extends State<ExerciseLibrarySheet> {
  int _selectedTab = 0; // 0=Library, 1=Manual
  String _selectedCategory = 'all';
  late List<ExerciseModel> _addedExercises;
  String _searchQuery = '';
  final TextEditingController _manualNameController = TextEditingController();
  final TextEditingController _manualSetsController = TextEditingController();
  final TextEditingController _manualRepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addedExercises = List.from(widget.initialAdded);
  }

  @override
  void dispose() {
    _manualNameController.dispose();
    _manualSetsController.dispose();
    _manualRepsController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredExercises {
    return widget.exercises.where((ex) {
      final name = ex['name'] as String? ?? '';
      final matchesSearch = name.toLowerCase().contains(_searchQuery.toLowerCase());
      final category = ex['muscle_group'] as String? ?? 'other';
      final matchesCategory = _selectedCategory == 'all' || category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: AppSizes.height(12)),
            width: AppSizes.width(40),
            height: AppSizes.height(4),
            decoration: BoxDecoration(
              color: AppColors.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(AppSizes.width(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Exercise', style: AppTextStyles.font18Bold),
                GestureDetector(
                  onTap: () {
                    widget.onDone(_addedExercises);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done (${_addedExercises.length})',
                    style: AppTextStyles.font14Regular.copyWith(
                      color: AppColors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                border: Border.all(color: AppColors.borderDefault, width: 1),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: AppTextStyles.font14Regular,
                decoration: InputDecoration(
                  icon: const Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
                  hintText: 'Search exercises...',
                  hintStyle: AppTextStyles.font14RegularMuted,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSizes.height(16)),

          // Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
            child: _TabToggle(
              tabs: const ['Library', 'Manual Entry'],
              selectedIndex: _selectedTab,
              onChanged: (index) => setState(() => _selectedTab = index),
            ),
          ),

          SizedBox(height: AppSizes.height(16)),

          // Tab Content
          Expanded(
            child: _selectedTab == 0 ? _buildLibraryTab() : _buildManualEntryTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryTab() {
    final categories = ['all', 'chest', 'back', 'shoulders', 'arms', 'legs', 'core'];
    return Column(
      children: [
        // Categories
        SizedBox(
          height: AppSizes.height(34),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final bool selected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.width(8)),
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16)),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.amber.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                    border: Border.all(
                      color: selected ? AppColors.amber : AppColors.borderDefault,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat.toUpperCase(),
                    style: AppTextStyles.font10SemiBold.copyWith(
                      color: selected ? AppColors.amber : AppColors.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: AppSizes.height(12)),

        // Exercise list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
            itemCount: _filteredExercises.length,
            itemBuilder: (context, index) {
              final exercise = _filteredExercises[index];
              final exerciseName = exercise['name'] as String? ?? 'Unknown';
              final category = exercise['muscle_group'] as String? ?? 'other';
              final bool isAdded = _addedExercises.any((e) => e.name == exerciseName);

              // Injury warning logic
              bool isInjuryWarning = false;
              if (widget.injuryKeywords != null && widget.injuryKeywords!.isNotEmpty) {
                const injuryMapping = {
                  'knee': 'legs',
                  'shoulder': 'shoulders',
                  'back': 'back',
                  'chest': 'chest',
                  'elbow': 'arms',
                  'wrist': 'arms',
                };
                
                for (final keyword in widget.injuryKeywords!) {
                  final mappedMuscle = injuryMapping[keyword.toLowerCase()];
                  if (mappedMuscle != null && category.toLowerCase() == mappedMuscle) {
                    isInjuryWarning = true;
                    break;
                  }
                }
              }

              return ExerciseListItem(
                name: exerciseName,
                muscleGroup: category,
                isAdded: isAdded,
                isInjuryWarning: isInjuryWarning,
                onToggle: () {
                  setState(() {
                    if (isAdded) {
                      _addedExercises.removeWhere((e) => e.name == exerciseName);
                    } else {
                      final int nextDay = _addedExercises.isEmpty 
                          ? 1 
                          : _addedExercises.map((e) => e.day).reduce((a, b) => a > b ? a : b) + 1;
                          
                      _addedExercises.add(ExerciseModel(
                        name: exerciseName,
                        sets: 4,
                        reps: 10,
                        day: nextDay,
                      ));
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildManualEntryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildManualField('Exercise Name', _manualNameController, 'e.g. Weighted Pullups'),
          SizedBox(height: AppSizes.height(20)),
          Row(
            children: [
              Expanded(child: _buildManualField('Sets', _manualSetsController, '4', keyboardType: TextInputType.number)),
              SizedBox(width: AppSizes.width(16)),
              Expanded(child: _buildManualField('Reps', _manualRepsController, '12', keyboardType: TextInputType.number)),
            ],
          ),
          SizedBox(height: AppSizes.height(32)),
          // Add button
          GestureDetector(
            onTap: () {
              if (_manualNameController.text.isNotEmpty) {
                setState(() {
                  final int sets = int.tryParse(_manualSetsController.text) ?? 4;
                  final int reps = int.tryParse(_manualRepsController.text) ?? 10;
                  final int nextDay = _addedExercises.isEmpty 
                      ? 1 
                      : _addedExercises.map((e) => e.day).reduce((a, b) => a > b ? a : b) + 1;

                  _addedExercises.add(ExerciseModel(
                    name: _manualNameController.text,
                    sets: sets,
                    reps: reps,
                    day: nextDay,
                  ));
                  _manualNameController.clear();
                  _manualSetsController.clear();
                  _manualRepsController.clear();
                  _selectedTab = 0; // Go back to library to see added count
                });
              }
            },
            child: Container(
              width: double.infinity,
              height: AppSizes.height(54),
              decoration: BoxDecoration(
                color: AppColors.amber,
                borderRadius: BorderRadius.circular(AppSizes.radius(16)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Add to Program',
                style: AppTextStyles.font16SemiBold.copyWith(color: AppColors.background),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualField(String label, TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.font10SemiBold.copyWith(color: AppColors.muted, letterSpacing: 0.8),
        ),
        SizedBox(height: AppSizes.height(8)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radius(12)),
            border: Border.all(color: AppColors.borderDefault, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.font14Regular,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.font14RegularMuted,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabToggle extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _TabToggle({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.width(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(12)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final bool selected = e.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: AppSizes.height(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius(10)),
                  color: selected ? AppColors.amber : Colors.transparent,
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: selected ? AppColors.background : AppColors.muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

