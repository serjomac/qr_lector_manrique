import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRACore/extensions/own-color-scheme.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/buttons/BRAButton.dart';
import 'package:qr_scaner_manrique/BRACore/api/api_auth.dart';

class CustomerDataModal extends StatefulWidget {
  const CustomerDataModal({Key? key}) : super(key: key);

  @override
  State<CustomerDataModal> createState() => _CustomerDataModalState();
}

class _CustomerDataModalState extends State<CustomerDataModal> {
  final _formKey = GlobalKey<FormState>();

  final _identificacionController = TextEditingController();
  final _mailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _nombreController = TextEditingController();

  final _identificacionFocusNode = FocusNode();
  final ApiAuth _apiAuth = ApiAuth();
  bool _isIdLookupLoading = false;

  String _tipoIdentificacion = 'cedula';

  @override
  void initState() {
    super.initState();
    _identificacionFocusNode.addListener(() {
      if (!_identificacionFocusNode.hasFocus) {
        _lookupByIdentificacion();
      }
    });
  }

  @override
  void dispose() {
    _identificacionController.dispose();
    _mailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _nombreController.dispose();
    _identificacionFocusNode.dispose();
    super.dispose();
  }

  Map<String, String> _collectData() {
    return {
      'tipo_identificacion': _tipoIdentificacion,
      'identificacion': _identificacionController.text.trim(),
      'mail_cliente': _mailController.text.trim(),
      'telefono': _telefonoController.text.trim(),
      'direccion_cliente': _direccionController.text.trim(),
      'nombre_cliente': _nombreController.text.trim(),
    };
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.back(result: _collectData());
    }
  }

  void _consumidorFinal() {
    Get.back(result: {
      'tipo_identificacion': '',
      'identificacion': '9999999999',
      'mail_cliente': '',
      'telefono': '',
      'direccion_cliente': '',
      'nombre_cliente': '',
    });
  }

  Future<void> _lookupByIdentificacion() async {
    // Aplicamos la lógica de lookup cuando es cédula o RUC
    if (_tipoIdentificacion != 'cedula' && _tipoIdentificacion != 'ruc') return;
    final id = _identificacionController.text.trim();
    if (id.isEmpty || id.length < 5) return;

    setState(() {
      _isIdLookupLoading = true;
    });
    try {
      final people = await _apiAuth.getPeopleDataBy(id);
      if (mounted && people.nombres != null && people.nombres!.isNotEmpty) {
        _nombreController.text = people.nombres!;
      }
    } catch (e) {
      // Silently ignore lookup errors, same as in manual flow
    } finally {
      if (mounted) {
        setState(() {
          _isIdLookupLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(69, 63, 61, 0.1),
              offset: Offset(0, 4),
              blurRadius: 15,
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: BRAText(
                        text: 'Datos de facturación',
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF231918),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cerrar',
                      splashRadius: 18,
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF998E8C),
                        size: 22,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tipo identificación
                BRAText(
                  text: 'Tipo identificación',
                  size: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5B5856),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _tipoIdentificacion,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'cedula', 
                          child: Text(
                            'Cédula',
                            style: TextStyle(color: theme.own().secundaryTextColor),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'ruc', 
                          child: Text(
                            'RUC',
                            style: TextStyle(color: theme.own().secundaryTextColor),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'pasaporte', 
                          child: Text(
                            'Pasaporte',
                            style: TextStyle(color: theme.own().secundaryTextColor),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _tipoIdentificacion = val;
                            // Limpiar el campo de identificación al cambiar el tipo
                            _identificacionController.clear();
                            _nombreController.clear(); // También limpiar nombre ya que puede haber datos del lookup anterior
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                _buildIdentificacionField(),
                _buildTextField(
                  label: 'Nombre', 
                  controller: _nombreController,
                  isRequired: true,
                ),
                _buildTextField(label: 'Correo', controller: _mailController, keyboardType: TextInputType.emailAddress),
                _buildTextField(label: 'Teléfono', controller: _telefonoController, keyboardType: TextInputType.phone),
                _buildTextField(label: 'Dirección', controller: _direccionController),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BRAButton(
                        label: 'Consumidor final',
                        onPressed: _consumidorFinal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BRAButton(
                        label: 'Enviar',
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentificacionField() {
    // Keyboard type dinámico: números para cédula/RUC, texto para pasaporte
    final keyboardType = (_tipoIdentificacion == 'cedula' || _tipoIdentificacion == 'ruc')
        ? TextInputType.number
        : TextInputType.text;

    // Input formatters según el tipo de identificación
    List<TextInputFormatter> inputFormatters = [];
    int? maxLength;
    
    switch (_tipoIdentificacion) {
      case 'cedula':
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
        maxLength = 10;
        break;
      case 'ruc':
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(13),
        ];
        maxLength = 13;
        break;
      case 'pasaporte':
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ];
        maxLength = null;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const BRAText(
              text: 'Identificación',
              size: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5B5856),
            ),
            const BRAText(
              text: ' *',
              size: 12,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _identificacionController,
          focusNode: _identificacionFocusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          onFieldSubmitted: (_) => _lookupByIdentificacion(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es requerido';
            }
            
            switch (_tipoIdentificacion) {
              case 'cedula':
                if (value.length != 10) {
                  return 'La cédula debe tener exactamente 10 números';
                }
                break;
              case 'ruc':
                if (value.length != 13) {
                  return 'El RUC debe tener exactamente 13 números';
                }
                break;
              case 'pasaporte':
                if (value.length < 6) {
                  return 'El pasaporte debe tener al menos 6 caracteres';
                }
                break;
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEB472A)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            counterText: '', // Oculta el contador de caracteres
            suffixIcon: _isIdLookupLoading
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                : null,
          ),
          style: const TextStyle(
            color: Color(0xFF534340),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BRAText(
              text: label,
              size: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5B5856),
            ),
            if (isRequired)
              const BRAText(
                text: ' *',
                size: 12,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: isRequired ? (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          } : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEB472A)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          style: const TextStyle(
            color: Color(0xFF534340),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
