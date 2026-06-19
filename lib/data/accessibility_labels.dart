class AccessibilityLabel {
  final String icon;
  final String label;
  const AccessibilityLabel({required this.icon, required this.label});
}

const Map<String, AccessibilityLabel> accessibilityLabels = {
  'ramp':             AccessibilityLabel(icon: '♿', label: 'Rampa de acesso'),
  'adapted_bathroom': AccessibilityLabel(icon: '🚻', label: 'Banheiro adaptado'),
  'pcd_parking':      AccessibilityLabel(icon: '🅿️', label: 'Vaga PCD'),
  'wheelchair_space': AccessibilityLabel(icon: '🪑', label: 'Espaço cadeirante'),
  'audio_signaling':  AccessibilityLabel(icon: '🔊', label: 'Sinalização sonora'),
  'braille':          AccessibilityLabel(icon: '👁️', label: 'Sinalização em Braille'),
  'guide_dog':        AccessibilityLabel(icon: '🐕', label: 'Aceita cão-guia'),
  'inclusive_service':AccessibilityLabel(icon: '🤝', label: 'Atendimento inclusivo'),
};

const List<Map<String, String>> categoryFilters = [
  {'key': 'all',        'label': 'Todos',       'icon': '🏠'},
  {'key': 'Restaurante','label': 'Restaurantes','icon': '🍽️'},
  {'key': 'Saúde',      'label': 'Saúde',       'icon': '🏥'},
  {'key': 'Comércio',   'label': 'Comércio',    'icon': '🛒'},
  {'key': 'Educação',   'label': 'Educação',    'icon': '🏫'},
  {'key': 'Público',    'label': 'Público',     'icon': '🏛️'},
  {'key': 'Hospedagem', 'label': 'Hospedagem',  'icon': '🏨'},
  {'key': 'Lazer',      'label': 'Lazer',       'icon': '🎭'},
  {'key': 'Serviços',   'label': 'Serviços',    'icon': '🏢'},
  {'key': 'Shopping',   'label': 'Shopping',    'icon': '🛍️'},
];

const Map<int, String> ratingLabels = {
  1: 'Péssimo',
  2: 'Ruim',
  3: 'Regular',
  4: 'Bom',
  5: 'Excelente',
};
