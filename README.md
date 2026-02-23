# BidderOS

Ruby on Rails API for resume matching and cover letter generation using OpenAI and pgvector.

## Requirements

- Ruby 3.2.3
- PostgreSQL 14+ with pgvector extension
- OpenAI API Key

## Environment Variables

Create a `.env` file in the `bidderOS_api/` root:

```env
OPENAI_API_KEY=sk-...
```

> Database credentials are already configured in `config/database.yml`. `SECRET_KEY_BASE` is managed by Rails credentials.

## Setup

```bash
# 1. Install dependencies
bundle install

# 2. Create and migrate the database
rails db:create db:migrate

# 3. Run the server
rails s -p 3000
```
The API will be available at `http://localhost:3000`.

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | `/api/v1/auth/register`                | Create account | No |
| POST | `/api/v1/auth/login`                   | Sign in (returns JWT) | No |
| GET  | `/api/v1/auth/me`                      | Current user info | Yes |
| GET  | `/api/v1/resumes`                      | List uploaded resumes | Yes |
| POST | `/api/v1/resumes`                      | Upload resumes (PDF/DOCX) | Yes |
| POST | `/api/v1/recommendations`              | Find best matching resumes | Yes |
| POST | `/api/v1/recommendations/cover_letter` | Generate cover letter | Yes |

Protected routes require `Authorization: Bearer <token>` header.

## Architecture Decisions

1. **Service Objects over Fat Controllers** — Logic is split into `EmbeddingService`, `CoverLetterService`, `ResumeProcessorService`, and `JwtService`. Controllers remain thin, delegating all intelligence to services, which makes each concern independently testable and replaceable.

2. **pgvector + `neighbor` gem for semantic search** — Instead of a separate vector database (Pinecone, Weaviate), embeddings live in the same PostgreSQL instance. This eliminates a cross-service network call, simplifies deployment, and keeps the infrastructure minimal with no loss in search quality for this scale.

3. **JWT over session-based auth** — Stateless tokens are the natural choice for a decoupled React frontend. No session store is needed on the server, making horizontal scaling trivial.

4. **OpenAI `text-embedding-3-small`** — Chosen for its outstanding cost-to-quality ratio. At 1536 dimensions it provides high-fidelity semantic similarity at a fraction of `ada-002`'s cost, which is ideal for a product where embeddings are generated on every upload and recommendation request.

5. **`OPENAI_API_KEY` via environment variable** — The key is never hardcoded. `dotenv-rails` loads `.env` in development; in production it is injected via the hosting environment, keeping secrets out of source control.

6. **PDF + DOCX support via `pdf-reader` and `docx` gems** — Both formats are first-class citizens with proper error handling. If a file is corrupted or produces no text (e.g. a scanned PDF), the service raises an explicit error that propagates to the API response, giving the frontend a clear, per-file failure message.
