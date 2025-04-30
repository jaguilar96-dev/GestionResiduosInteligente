# GestionResiduosInteligente
# Sistema Inteligente de Gestión de Residuos Sólidos Urbanos

Este repositorio contiene la estructura de base de datos para un sistema de gestión inteligente de residuos sólidos urbanos, orientado a apoyar a las municipalidades en la recolección eficiente de residuos mediante participación ciudadana, rutas optimizadas y seguimiento supervisado.

---

## 📦 Estructura de Tablas

### 🧑 Usuarios
Registra a todos los actores del sistema: ciudadanos, operarios, supervisores y administradores.

### 🏠 Direcciones
Guarda las ubicaciones asociadas a los usuarios, necesarias para geolocalizar reportes o servicios.

### 🌍 Zonas
Define las áreas geográficas gestionadas por el sistema, como distritos o sectores.

### 🗑️ TiposResiduo
Clasifica los residuos (orgánico, reciclable, peligroso), permitiendo un tratamiento diferenciado.

### 🚛 Vehiculos
Registra los medios de transporte utilizados en la recolección: camiones, furgonetas, etc.

### 🧭 Rutas
Asocia zonas con vehículos y personal para planificar recorridos de recolección.

### 🚨 Reportes
Alertas generadas por ciudadanos cuando identifican puntos críticos de acumulación de residuos.

### 🧹 AtencionIncidencias
Registra quién atiende cada reporte, en qué fecha y con qué resultado.

### ✅ Validaciones
Permite que un supervisor verifique si la atención fue efectiva y adecuada.

### 🔔 Notificaciones
Informa a los usuarios sobre el estado de sus reportes o actividades relevantes del sistema.

### 📊 HistorialRecoleccion
Guarda los registros de cada servicio de recolección, incluyendo toneladas recogidas y kilómetros recorridos.

---

## 🛠️ Tecnologías
- SQL Server
- Transact-SQL (T-SQL)
- Modelo relacional normalizado

---

## 📄 Licencia
Este proyecto puede adaptarse libremente para fines académicos y de investigación.

