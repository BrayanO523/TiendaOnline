import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiendaonline/presentation/providers/providers.dart';
import 'package:tiendaonline/domain/entities/admin_product.dart';
import 'package:tiendaonline/domain/entities/product.dart';
import 'package:tiendaonline/data/models/product_model.dart'; // For converting implementations, simplified usage

class AdminProductEditScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AdminProductEditScreen({super.key, this.productId});

  @override
  ConsumerState<AdminProductEditScreen> createState() =>
      _AdminProductEditScreenState();
}

class _AdminProductEditScreenState
    extends ConsumerState<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool _isLoading = false;
  File? _selectedImage;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    // In real app, avoid putting async in init, use FutureBuilder or Riverpod async init
    // For prototype, we'll fetch once.
    // However, since we don't have a direct "getById" exposed easily via provider without args,
    // we can use ref.read(getAdminProductByIdUseCaseProvider).call(id) inside a Future.

    // Better: Helper function
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final useCase = ref.read(getAdminProductByIdUseCaseProvider);
      final product = await useCase.call(widget.productId!);
      if (product != null) {
        _popluateForm(product);
      }
    });
  }

  void _popluateForm(AdminProduct p) {
    _titleCtrl.text = p.title;
    _priceCtrl.text = p.price.base.toString();
    _costCtrl.text = p.cost.toString();
    _descCtrl.text = p.description;
    if (p.images.isNotEmpty) {
      setState(() {
        _currentImageUrl = p.images.first.url;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String imageUrl =
          _currentImageUrl ??
          'https://placehold.co/600x400/png?text=Sin+Imagen';

      if (_selectedImage != null) {
        final storage = ref.read(storageServiceProvider);
        imageUrl = await storage.uploadImage(_selectedImage!);
      }

      final newProduct = AdminProduct(
        id: widget.productId ?? '', // Empty ID for new, existing for update
        status: 'activo', // Default to active for now
        title: _titleCtrl.text,
        slug:
            _titleCtrl.text.toLowerCase().replaceAll(' ', '-') +
            '-${DateTime.now().millisecondsSinceEpoch}', // Simple unique slug
        shortDescription: _descCtrl.text,
        description: _descCtrl.text,
        brandId: '', // TODO: Add Brand Picker
        brandName: 'Genérica',
        categoryIds: [], // TODO: Add Category Picker
        images: [
          ProductImageModel(url: imageUrl, alt: _titleCtrl.text, order: 0),
        ],
        price: ProductPriceModel(
          currency: 'HNL',
          base: double.tryParse(_priceCtrl.text) ?? 0.0,
        ),
        hasVariants: false,
        variants: [],
        technicalSpecs: {},
        extraSpecs: {},
        warranty: ProductWarrantyModel(
          months: 0,
          type: 'N/A',
          conditions: 'N/A',
        ),
        shipping: ProductShippingModel(
          requiresShipping: true,
          weightGrams: 0,
          lithiumBattery: false,
        ),
        rating: ProductRatingModel(average: 0, count: 0),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // Admin
        cost: double.tryParse(_costCtrl.text) ?? 0.0,
        supplierId: '',
        supplierName: '',
        warehouseLocation: '',
        internalNotes: '',
        adminUpdatedAt: DateTime.now(),
      );

      await ref.read(catalogRepositoryProvider).saveProduct(newProduct);

      // Force refresh of the list
      ref.invalidate(adminProductsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto guardado exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'Nuevo Producto' : 'Editar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : (_currentImageUrl != null
                            ? Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              )),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _costCtrl,
                      decoration: const InputDecoration(labelText: 'Costo'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Precio Venta',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Producto'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
