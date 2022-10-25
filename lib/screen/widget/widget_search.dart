import 'package:flutter/cupertino.dart';

import '_widget.dart';

class HomePrefixText extends StatelessWidget {
  const HomePrefixText(
    this.text, {
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: context.theme.textTheme.labelMedium?.copyWith(
          color: color ?? CupertinoColors.systemGrey,
        ),
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  const HomeListTile({
    Key? key,
    required this.onPressed,
    required this.leading,
    required this.title,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return CustomButton(
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomListTile(
        tileColor: theme.canvasColor,
        title: title,
        height: 35.0,
        leading: SizedBox(
          width: 16.0,
          child: leading,
        ),
        trailing: const Icon(
          CupertinoIcons.pen,
          color: CupertinoColors.systemGrey,
          size: 20.0,
        ),
      ),
    );
  }
}

class HomeLocationSearchTextField extends StatelessWidget {
  const HomeLocationSearchTextField({
    super.key,
    this.autofocus = false,
    this.enabled = true,
    this.controller,
    this.prefixText,
    this.placeholder,
    this.focusNode,
    this.onTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? placeholder;
  final VoidCallback? onTap;
  final Widget? prefixText;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 3.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: HomeSearchTextField(
        placeholder: placeholder,
        prefixText: prefixText,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}
