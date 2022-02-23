import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStyles {
  static Widget getInput({
    required BuildContext context,
    required TextEditingController controller,
    required String texto,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    bool hasAutoValidate = false,
    int? maxLength,
    bool numberFormat = false,
    bool isTheLast = false,
    bool isTheFirst = false,
    bool checking = false,
    Map? view,
    bool obscureText = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: 20,
        left: 20,
        bottom: isTheLast ? 0 : 20,
        top: isTheFirst ? 20 : 0,
      ),
      child: TextFormField(
        controller: controller,
        style: Theme.of(context).textTheme.bodyText2,
        inputFormatters: [
          if(numberFormat) FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          suffixIcon: checking ?
          Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF63911d))),
          ) : (
            view != null ?
            IconButton(
              onPressed: view['onPressed'],
              icon: Icon(view['obscure'] ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              color: Theme.of(context).primaryColor,
            ) : null
          ),
          labelText: texto.toUpperCase(),
          labelStyle: Theme.of(context).textTheme.caption?.apply(fontSizeDelta: 5),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        obscureText: obscureText,
        autovalidateMode: hasAutoValidate ? AutovalidateMode.onUserInteraction : null,
        validator: validator,
        onChanged: onChanged,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        maxLines: maxLength != null ? maxLength ~/ 100 : 1,
        readOnly: readOnly,
      )
    );
  }

  static Widget getOutlinedButton({
    required BuildContext context,
    required Function() onPressed,
    String? texto,
    IconData? icone,
    double? tamanho,
    bool radius = false,
    EdgeInsetsGeometry? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 15),
      child: Center(
        child: OutlinedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icone != null) Icon(icone, size: tamanho),
              if(texto != null) Text(texto.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getElevatedButton({
    required String texto,
    required Function() onPressed,
    IconData? icone,
    EdgeInsetsGeometry? padding,
    bool minSize = true,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.only(
        top: 20,
        right: minSize ? 0 : 20,
        left: minSize ? 0 : 20,
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: minSize ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icone != null) Icon(icone),
              Text(texto.toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }

  static Widget getTextButton({
    required String texto,
    required Function() onPressed,
    IconData? icone,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icone != null) Icon(icone),
              Text(texto),
            ],
          ),
        ],
      ),
    );
  }

  static Widget getIndicadorPaginacao({
    required BuildContext context,
    required List paginas,
    required int currentPage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(paginas.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 10,
          width: index == currentPage ? 15 : 10,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: index == currentPage ?
            Theme.of(context).primaryColor :
            Theme.of(context).disabledColor,
          ),
        );
      }),
    );
  }
}