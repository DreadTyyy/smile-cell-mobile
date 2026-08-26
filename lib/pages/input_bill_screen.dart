import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smile_cell/data/models/bill_model.dart';

class InputBillScreen extends StatefulWidget {
  const InputBillScreen({
    super.key,
    required this.biller,
  });

  final Biller biller;

  @override
  State<InputBillScreen> createState() => _InputBillScreenState();
}

class _InputBillScreenState extends State<InputBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.removeListener(() => setState(() {}));
    super.dispose();
  }

  bool get _isComplete => _controller.text.length >= widget.biller.rule.minLength;

  String? _onValidate(String? value) {
    final text = value ?? "";
    if (text.isEmpty) return 'Nomor tagihan wajib diisi';
    if (text.length < widget.biller.rule.minLength) return 'Nomor tagihan minimum ${widget.biller.rule.minLength} digit';

    return null;
  }

  void _submitCheckBill() {
    if (_formKey.currentState?.validate() != true) return;

    FocusScope.of(context).unfocus(); 
    // TODO: Fungsi untuk cek tagihan user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          widget.biller.name,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600
          )
        ),
        centerTitle: true,
        elevation: 0.0,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_rounded)
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, thickness: 1.0, color: Color(0xFFDDDDDD))
        )
      ),
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    Text(
                      "Nomor Tagihan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: Color(0xCC000000),
                      )
                    ),
                    TextFormField(
                      controller: _controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.go,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: _onValidate,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(widget.biller.rule.maxLength)
                      ],
                      onFieldSubmitted: (_) => _submitCheckBill(),

                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintText: "Masukkan nomor tagihan",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                          height: 1.2
                        ),
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 14.0
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: _border(Color(0xFFDDDDDD)),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary),
                        errorBorder: _border(Theme.of(context).colorScheme.error),
                        focusedErrorBorder: _border(Theme.of(context).colorScheme.error),
                        border: _border(Color(0xFFDDDDDD))
                      ),
                    )
                  ]
                ),
              ),
          
              Spacer(),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54.0,
                  child: ElevatedButton(
                    onPressed: _isComplete ? _submitCheckBill : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 0.0,
                      ),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Cek Tagihan",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          
              const SizedBox(height: 24.0),
            ],
          ),
        )
      )
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0)
  );
}
