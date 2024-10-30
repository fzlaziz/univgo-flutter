import 'package:univ_go/models/filter/filter_model.dart';

Map<String, List<Filter>> filters = {
  'Lokasi': [
    Filter(label: 'Tembalang', id: 3181, group: 'location'),
    Filter(label: 'Banyumanik', id: 3182, group: 'location'),
    Filter(label: 'Gunungpati', id: 3183, group: 'location'),
    Filter(label: 'Semarang Tengah', id: 3172, group: 'location'),
  ],
  'Level Studi': [
    Filter(label: 'S1', id: 1, group: 'study_level'),
    Filter(label: 'S2', id: 2, group: 'study_level'),
    Filter(label: 'S3', id: 3, group: 'study_level'),
    Filter(label: 'D2', id: 4, group: 'study_level'),
    Filter(label: 'D3', id: 5, group: 'study_level'),
    Filter(label: 'D4', id: 6, group: 'study_level'),
  ],
  'Jalur Masuk': [
    Filter(label: 'Mandiri', id: 1, group: 'entry_path'),
    Filter(label: 'SNBP', id: 2, group: 'entry_path'),
    Filter(label: 'Beasiswa', id: 3, group: 'entry_path'),
    Filter(label: 'UTBK', id: 4, group: 'entry_path'),
  ],
  'Akreditasi': [
    Filter(label: 'Unggul', id: 1, group: 'accreditation'),
    Filter(label: 'Baik Sekali', id: 2, group: 'accreditation'),
    Filter(label: 'Baik', id: 3, group: 'accreditation'),
    Filter(label: 'A', id: 4, group: 'accreditation'),
    Filter(label: 'B', id: 5, group: 'accreditation'),
    Filter(label: 'C', id: 6, group: 'accreditation'),
  ],
  'Jenis PTN': [
    Filter(label: 'PTN', id: 1, group: 'campus_type'),
    Filter(label: 'Politeknik', id: 2, group: 'campus_type'),
    Filter(label: 'Swasta', id: 3, group: 'campus_type'),
  ],
};
