import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  /// Creates a material design [TabBar] tab. At least one of [text], [icon],
  /// and [child] must be non-null. The [text] and [child] arguments must not be
  /// used at the same time.
  const CustomTab({
    Key key,
    this.text,
    this.icon,
    this.child,
    this.height = 46,
  })  : assert(text != null || child != null || icon != null),
        assert(!(text != null && null != child)), // TODO(goderbauer): https://github.com/dart-lang/sdk/issues/34180
        super(key: key);

  /// The text to display as the tab's label.
  ///
  /// Must not be used in combination with [child].
  final String text;

  /// The widget to be used as the tab's label.
  ///
  /// Usually a [Text] widget, possibly wrapped in a [Semantics] widget.
  ///
  /// Must not be used in combination with [text].
  final Widget child;

  /// An icon to display as the tab's label.
  final Widget icon;

  final double height;

  Widget _buildLabelText() {
    return child ?? Text(text, softWrap: false, overflow: TextOverflow.fade);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    double height;
    Widget label;
    if (icon == null) {
      height = height;
      label = _buildLabelText();
    } else if (text == null && child == null) {
      height = height;
      label = icon;
    } else {
      height = height;
      label = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: icon,
            margin: const EdgeInsets.only(bottom: 10.0),
          ),
          _buildLabelText(),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: Center(
        child: label,
        widthFactor: 1.0,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('icon', icon, defaultValue: null));
  }
}
