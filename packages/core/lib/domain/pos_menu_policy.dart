import 'auth_policy.dart';
import 'pos_menu_entry.dart';
import 'pos_template_definition.dart';
import 'pos_template_id.dart';
import 'user_role.dart';

class PosMenuPolicy {
  static List<PosMenuEntry> visibleEntries(
    UserRole role,
    PosTemplate template,
  ) {
    final result = <PosMenuEntry>[];
    for (final entry in PosMenuEntry.values) {
      if (!template.hasFeature(entry.feature)) continue;
      if (!AuthPolicy.allows(role, entry.permission)) continue;
      result.add(entry);
    }
    return result;
  }

  static List<PosMenuEntry> visibleForTemplateId(
    UserRole role,
    PosTemplateId templateId,
  ) {
    final def = PosTemplateRegistry.resolve(templateId);
    return visibleEntries(role, def.toPosTemplate());
  }
}