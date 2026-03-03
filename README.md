# Ally

Book review and learning community. Backend: **Java 21**, **Spring Boot**, **Thymeleaf**, **JPA**. Database: **PostgreSQL**. Frontend: **TypeScript**.

## Requirements

- Java 21+
- PostgreSQL
- Node.js 18+ (for frontend build)

Maven はプロジェクトに同梱の **Maven Wrapper** で自動利用します（別途 Maven のインストール不要）。  
**JAVA_HOME** に Java 21 の JDK を指すように設定してください。初回実行時に Maven が自動ダウンロードされます。

## Setup

### 1. PostgreSQL

Create database and user:

```sql
CREATE DATABASE ally;
CREATE USER ally WITH PASSWORD 'ally';
GRANT ALL PRIVILEGES ON DATABASE ally TO ally;
```

### 2. Environment

Copy and edit env (optional; defaults in `application.yml`):

- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` — PostgreSQL
- `RAKUTEN_APP_ID` — [Rakuten API](https://webservice.rakuten.co.jp/) Application ID (for book search)

### 3. Run

**Windows (PowerShell / コマンドプロンプト):**
```cmd
.\mvnw.cmd spring-boot:run
```

**macOS / Linux:**
```bash
./mvnw spring-boot:run
```

（`mvn` がインストール済みなら `mvn spring-boot:run` でも可。）

Open: http://localhost:8080

### 4. Admin

Create an admin user in the database (password must be BCrypt):

```sql
INSERT INTO admins (email, encrypted_password, created_at, updated_at)
VALUES ('admin@example.com', '$2a$10$...', NOW(), NOW());
```

Generate BCrypt hash with Spring or any BCrypt tool, then replace `$2a$10$...` above.

### 5. Frontend (TypeScript)

```bash
npm install
npm run build
```

Output goes to `src/main/resources/static/js/`. Use `npm run watch` during development.

## Project structure

- `src/main/java/com/ally/` — Application, config, controllers, entities, repositories, security, services
- `src/main/resources/templates/` — Thymeleaf (public/, admin/)
- `src/main/resources/static/` — CSS, JS, images
- `frontend/ts/` — TypeScript source

## License

© All rights reserved by Ally for learners.
