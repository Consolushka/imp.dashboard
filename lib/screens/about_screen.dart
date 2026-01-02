import 'package:flutter/material.dart';

class AboutImpScreen extends StatelessWidget {
  const AboutImpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Как это работает?'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildFormulaSection(context),
                const SizedBox(height: 24),
                _buildPerSection(context),
                const SizedBox(height: 24),
                _buildReliabilitySection(context),
                const SizedBox(height: 24), // <--- Добавляем отступ
                _buildFinalSummary(context), // <--- Наш новый абзац
                const SizedBox(height: 24),
                _buildExamplesSection(context), // <--- Наши примеры
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'IMP: Честная эффективность',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Стандартный «Плюс-Минус» (+/-) часто обманывает: игрок может получить «плюс», просто сидя на скамейке или играя рядом с лидером. \n\nМы создали IMP (Individual Match Performance), чтобы показать реальный вклад игрока относительно результата его команды.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaSection(BuildContext context) {
    // Стили для математических символов
    final mathStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontFamily: 'Courier', // Моноширинный шрифт для "математичности"
    );

    final variableStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final descStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[700],
      height: 1.3,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Формула Clean IMP',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // --- Блок с Визуальной Формулой ---
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Левая часть: IMP =
                Text('IMP', style: mathStyle.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0), // Небольшая коррекция для выравнивания
                  child: Text(' clean', style: mathStyle.copyWith(fontSize: 14, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(width: 12),
                Text('=', style: mathStyle.copyWith(fontSize: 22)),
                const SizedBox(width: 12),

                // Правая часть: Дробь
                Column(
                  children: [
                    // Числитель
                    Text('(Player ±)  —  (Team Diff)', style: mathStyle),

                    const SizedBox(height: 4),
                    // Черта дроби
                    Container(
                      height: 2,
                      width: 240, // Фиксированная ширина черты
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 4),

                    // Знаменатель
                    Text('Minutes Played', style: mathStyle),
                  ],
                ),
              ],
            ),
          ),
          // ----------------------------------

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // --- Расшифровка (Легенда) ---
          Text(
            'Обозначения:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),

          _buildLegendItem(
              variable: 'Player ±',
              description: 'Личный «Плюс-Минус» игрока. Разница очков, набранных и пропущенных командой за время его нахождения на паркете.',
              vStyle: variableStyle, dStyle: descStyle
          ),
          const SizedBox(height: 12),

          _buildLegendItem(
              variable: 'Team Diff',
              description: 'Финальная разница в счете матча (Очки команды — Очки соперника).',
              vStyle: variableStyle, dStyle: descStyle
          ),
          const SizedBox(height: 12),

          _buildLegendItem(
              variable: 'Minutes Played',
              description: 'Точное количество минут, проведенных игроком в игре.',
              vStyle: variableStyle, dStyle: descStyle
          ),
        ],
      ),
    );
  }

  // Вспомогательный виджет для строки легенды
  Widget _buildLegendItem({
    required String variable,
    required String description,
    required TextStyle vStyle,
    required TextStyle dStyle
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110, // Фиксированная ширина для названия переменной
          child: Text(variable, style: vStyle),
        ),
        Expanded(
          child: Text(description, style: dStyle),
        ),
      ],
    );
  }

  Widget _buildPerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Прогнозы (Per)',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Чтобы сравнивать игроков, сыгравших разное время, мы умножаем Clean IMP на три сценарные дистанции:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _buildPerCard(
          context,
          title: 'Per Bench',
          subtitle: 'Прогноз на половину игры',
          description: 'Идеально для оценки эффективности запасных игроков.',
          icon: Icons.chair_alt_outlined,
        ),
        const SizedBox(height: 12),
        _buildPerCard(
          context,
          title: 'Per Start',
          subtitle: 'Прогноз на 3/4 игры',
          description: 'Показывает уровень игрока стартовой пятерки.',
          icon: Icons.sports_basketball_outlined,
        ),
        const SizedBox(height: 12),
        _buildPerCard(
          context,
          title: 'Per FullGame',
          subtitle: 'Полное время',
          description: 'Теоретический максимум: что было бы, если бы игрок не уходил с площадки.',
          icon: Icons.star_border,
        ),
      ],
    );
  }

  Widget _buildPerCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String description,
        required IconData icon,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black, // Черный акцент
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReliabilitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Достоверность (Reliability)',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Можно ли верить цифрам, если новичок вышел на 1 минуту и случайно забил? Нет. \n\nНаша система "умной достоверности" снижает рейтинг IMP, если игрок провел на площадке недостаточно времени для объективной оценки. Чем ближе время игрока к эталону (Bench/Start/Full), тем точнее IMP.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: 24),

        // Место под твой график
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Здесь будет твоя картинка (Image.asset)
              Image.asset('assets/images/reliability_chart_ru.png', fit: BoxFit.contain),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Пример того, как растет доверие к статистике с каждой минутой',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Что в итоге показывает IMP?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black, // Инвертированный стиль для выделения главного вывода
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'IMP Per 36 говорит нам о том, насколько отличался бы финальный счет матча, если бы этот игрок провел на площадке ровно 36 минут в своем текущем темпе. \n\n*Если игрок отыграл больше 36 минут, показатель учитывает его реальный вклад с поправкой на физическую нагрузку.',
            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Разбор сценариев',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildExampleCard(
          context,
          title: 'Невидимый герой',
          subtitle: 'Команда проиграла -15, Игрок +2',
          impact: 'IMP Per 36: ≈ +20.5',
          description: 'Пока игрок был в игре — команда вела. Как только он сел — случился провал. IMP подсвечивает его реальную ценность.',
          icon: Icons.shield_outlined,
          color: Colors.green[700]!,
        ),
        const SizedBox(height: 12),
        _buildExampleCard(
          context,
          title: 'Пассажир в системе',
          subtitle: 'Команда выиграла +30, Игрок +10',
          impact: 'IMP Per 36: ≈ -18.0',
          description: 'Без игрока команда играла намного лучше. Несмотря на личный «плюс», он замедлял общий темп победы.',
          icon: Icons.directions_bus_outlined,
          color: Colors.orange[800]!,
        ),
        const SizedBox(height: 12),
        _buildExampleCard(
          context,
          title: 'Мусорное время',
          subtitle: 'Сыграна 1 минута, Игрок +3',
          impact: 'IMP Per 36: ≈ +0.8',
          description: 'Темп игрока за минуту — запредельный, но Reliability (достоверность) прижимает результат к нулю, защищая от случайных цифр.',
          icon: Icons.timer_outlined,
          color: Colors.blue[800]!,
        ),
      ],
    );
  }

  Widget _buildExampleCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String impact,
        required String description,
        required IconData icon,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text(impact, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }
}
