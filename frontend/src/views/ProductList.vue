<template>
  <div class="product-list">
    <div class="header">
      <h2>Produktverwaltung</h2>
      <button @click="showCreateModal = true" class="btn btn-primary">
        ➕ Neues Produkt
      </button>
    </div>

    <div v-if="error" class="alert alert-error">
      {{ error }}
    </div>

    <div v-if="loading" class="loading">
      Lade Produkte...
    </div>

    <div v-else-if="products.length === 0" class="empty-state">
      <p>Keine Produkte vorhanden. Erstelle dein erstes Produkt!</p>
    </div>

    <div v-else class="product-grid">
      <div v-for="product in products" :key="product.id" class="product-card">
        <h3>{{ product.name }}</h3>
        <p class="description">{{ product.description }}</p>
        <div class="product-details">
          <span class="price">{{ formatPrice(product.price) }}</span>
          <span class="stock" :class="{ 'low-stock': product.stock < 5 }">
            Lager: {{ product.stock }}
          </span>
        </div>
        <div class="actions">
          <button @click="editProduct(product)" class="btn btn-small">
            ✏️ Bearbeiten
          </button>
          <button @click="removeProduct(product.id!)" class="btn btn-small btn-danger">
            🗑️ Löschen
          </button>
        </div>
      </div>
    </div>

    <!-- Create/Edit Modal -->
    <div v-if="showCreateModal || showEditModal" class="modal-overlay" @click.self="closeModals">
      <div class="modal">
        <div class="modal-header">
          <h3>{{ showEditModal ? 'Produkt bearbeiten' : 'Neues Produkt' }}</h3>
          <button @click="closeModals" class="close-btn">✕</button>
        </div>
        <form @submit.prevent="saveProduct">
          <div class="form-group">
            <label>Name *</label>
            <input v-model="formData.name" type="text" required />
          </div>
          <div class="form-group">
            <label>Beschreibung</label>
            <textarea v-model="formData.description" rows="3"></textarea>
          </div>
          <div class="form-group">
            <label>Preis (€) *</label>
            <input v-model.number="formData.price" type="number" step="0.01" min="0" required />
          </div>
          <div class="form-group">
            <label>Lagerbestand *</label>
            <input v-model.number="formData.stock" type="number" min="0" required />
          </div>
          <div class="modal-actions">
            <button type="button" @click="closeModals" class="btn">Abbrechen</button>
            <button type="submit" class="btn btn-primary">Speichern</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useProductStore } from '@/stores/productStore'
import { storeToRefs } from 'pinia'
import type { Product } from '@/types'

const store = useProductStore()
const { products, loading, error } = storeToRefs(store)

const showCreateModal = ref(false)
const showEditModal = ref(false)
const editingProduct = ref<Product | null>(null)

const formData = ref<Product>({
  name: '',
  description: '',
  price: 0,
  stock: 0
})

onMounted(() => {
  store.fetchProducts()
})

function formatPrice(price: number): string {
  return new Intl.NumberFormat('de-DE', {
    style: 'currency',
    currency: 'EUR'
  }).format(price)
}

function editProduct(product: Product) {
  editingProduct.value = product
  formData.value = { ...product }
  showEditModal.value = true
}

async function removeProduct(id: number) {
  if (confirm('Möchtest du dieses Produkt wirklich löschen?')) {
    await store.deleteProduct(id)
  }
}

async function saveProduct() {
  try {
    if (showEditModal.value && editingProduct.value) {
      await store.updateProduct(editingProduct.value.id!, formData.value)
    } else {
      await store.createProduct(formData.value)
    }
    closeModals()
  } catch (e) {
    // Error handling is done in store
  }
}

function closeModals() {
  showCreateModal.value = false
  showEditModal.value = false
  editingProduct.value = null
  formData.value = {
    name: '',
    description: '',
    price: 0,
    stock: 0
  }
}
</script>

<style scoped>
.product-list {
  padding: 2rem 0;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.product-card {
  background: white;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 1.5rem;
  transition: box-shadow 0.3s;
}

.product-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.product-card h3 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
}

.description {
  color: #666;
  font-size: 0.9rem;
  margin-bottom: 1rem;
  min-height: 3rem;
}

.product-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 0.75rem;
  background: #f8f9fa;
  border-radius: 4px;
}

.price {
  font-size: 1.25rem;
  font-weight: bold;
  color: #27ae60;
}

.stock {
  font-weight: 500;
  color: #27ae60;
}

.stock.low-stock {
  color: #e74c3c;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.loading {
  text-align: center;
  padding: 3rem;
  color: #666;
}

.empty-state {
  text-align: center;
  padding: 3rem;
  color: #666;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.modal-header h3 {
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
}

.form-group {
  margin-bottom: 1rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #2c3e50;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
  font-family: inherit;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #3498db;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1.5rem;
}
</style>

