# PresenSense

> Smart face recognition attendance system with real-time emotion detection

![React](https://img.shields.io/badge/React-19.1.1-61DAFB?logo=react)
![FastAPI](https://img.shields.io/badge/FastAPI-0.116.1-009688?logo=fastapi)
![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python)
![License](https://img.shields.io/badge/License-MIT-blue)

## Overview

PresenSense is a full-stack attendance system combining facial recognition, emotion detection, and attention tracking. Built with React and FastAPI, it uses DeepFace and MediaPipe for accurate, real-time biometric analysis.

**Key Features:**
- 🎯 Real-time face recognition with DeepFace (Facenet)
- 😊 Emotion detection and attention tracking
- 📷 Multi-camera support with fullscreen mode
- 👤 Admin panel for user and attendance management
- ☁️ Google Cloud Storage integration
- 🔄 Attendance deduplication

## Tech Stack

### Frontend
- React 19.1.1 + Vite 7.1.2
- React Router DOM 7.8.2
- Tailwind CSS 4.1.13
- ESLint 9.33.0

### Backend
- FastAPI 0.116.1 + Uvicorn 0.35.0
- SQLAlchemy 2.0.43
- DeepFace 0.0.95 + MediaPipe 0.10.18
- TensorFlow 2.19.1 + OpenCV 4.12.0.88
- Google Cloud Storage 3.3.0

## Quick Start

### Prerequisites
- Node.js 18+
- Python 3.8+
- ~2GB disk space (for AI models)

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/SN7k/presensense.git
cd presensense
```

**2. Backend Setup**
```bash
cd server
python -m venv .venv
# Windows
.venv\Scripts\activate
# Linux/Mac
source .venv/bin/activate

pip install -r requirements.txt
python main.py
```

**3. Frontend Setup** (New terminal)
```bash
cd frontend
npm install
npm run dev
```

**4. Access Application**
- Frontend: http://localhost:5175
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Configuration

### Frontend (.env.local)
```env
VITE_API_BASE_URL=http://localhost:8000
```

### Backend (Environment Variables)
```env
# Database
DATABASE_URL=sqlite:///./backend.db

# Google Cloud Storage (Optional)
GCP_PROJECT_ID=your-project-id
GCP_BUCKET_NAME=your-bucket-name
GCP_CREDENTIALS_PATH=/path/to/credentials.json

# Face Recognition
MATCH_THRESHOLD=0.6
ATTENDANCE_DEDUP_SECONDS=300
```

## Project Structure

```
presensense/
├── frontend/              # React application
│   ├── src/
│   │   ├── components/   # UI components
│   │   ├── pages/        # Page components
│   │   ├── layouts/      # Layout templates
│   │   └── config.js     # API configuration
│   ├── package.json
│   └── vite.config.js
│
├── server/               # FastAPI backend
│   ├── models/          # AI/ML models
│   ├── routes/          # API endpoints
│   ├── utils/           # Utility functions
│   ├── main.py          # App entry point
│   ├── db.py            # Database models
│   └── requirements.txt
│
└── README.md
```

## API Endpoints

### User Management
```http
POST /admin/upload          # Register user with image
GET  /admin/attendance      # Get attendance records
```

### Face Recognition
```http
POST /match/               # Verify face and log attendance
POST /match/stream         # Stream processing
```

### Emotion Detection
```http
POST /emotion/start-session   # Start emotion analysis
POST /emotion/analyze-frame   # Analyze frame
```

### Health Check
```http
GET /health               # Health status
GET /ready                # Readiness probe
```

## Features

### Face Recognition
- Facenet-based face embeddings (128-dimension)
- Cosine similarity matching (threshold: 0.6)
- Automatic attendance logging
- 5-minute deduplication window

### Emotion Detection
- 7 emotion categories (happy, sad, angry, fear, surprise, disgust, neutral)
- Real-time confidence scores
- Eye gaze tracking with MediaPipe
- Attention percentage metrics

### Camera Interface
- Front/back camera switching
- Fullscreen mode with navbar hiding
- Stream persistence during transitions
- Automatic error recovery

### Admin Panel
- File upload or camera capture registration
- Real-time attendance monitoring
- User management
- Session-based authentication

## Deployment

### Backend (Google Cloud Run)
```bash
cd server
gcloud run deploy presensense-backend \
  --source . \
  --platform managed \
  --region asia-south1 \
  --allow-unauthenticated
```

### Frontend (Netlify)
```bash
cd frontend
npm run build
# Deploy dist/ folder to Netlify
```

Update frontend `.env.local`:
```env
VITE_API_BASE_URL=https://your-backend-url.run.app
```

## Troubleshooting

### Camera Not Working
- Ensure HTTPS in production (camera requires secure context)
- Check browser permissions
- Verify camera availability

### Model Loading Errors
- Check internet connection for model downloads
- Ensure ~2GB disk space
- Verify Python 3.8+ compatibility

### Poor Recognition Accuracy
- Adjust `MATCH_THRESHOLD` (lower = more lenient)
- Ensure good lighting conditions
- Use front-facing camera for registration
- Check image quality

### Database Issues
- Verify write permissions in server directory
- Check `DATABASE_URL` configuration
- For PostgreSQL: `DATABASE_URL=postgresql://user:pass@host:5432/db`

## Security

**Important:** Change default admin credentials!
- Location: `frontend/src/config.js`
- Default: `admin` / `admin123`

**Best Practices:**
- Use HTTPS in production
- Enable CORS only for trusted domains
- Implement rate limiting
- Regular security audits
- Follow biometric data regulations (GDPR, etc.)

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create feature branch (`git checkout -b feature/name`)
3. Commit changes (`git commit -m 'Add feature'`)
4. Push to branch (`git push origin feature/name`)
5. Open Pull Request

**Code Style:**
- Frontend: ESLint rules (React hooks)
- Backend: PEP 8 Python style guide
- Commit messages: Conventional commits

## License

MIT License - see [LICENSE](LICENSE) for details

**Third-party licenses:**
- DeepFace: MIT
- MediaPipe: Apache 2.0
- TensorFlow: Apache 2.0
- FastAPI: MIT
- React: MIT

## Support

- **Issues:** [GitHub Issues](https://github.com/SN7k/presensense/issues)
- **Discussions:** [GitHub Discussions](https://github.com/SN7k/presensense/discussions)

## Acknowledgments

Built with:
- [DeepFace](https://github.com/serengil/deepface) - Face recognition
- [MediaPipe](https://google.github.io/mediapipe/) - Face mesh & eye tracking
- [FastAPI](https://fastapi.tiangolo.com/) - Backend framework
- [React](https://react.dev/) - Frontend library
- [Tailwind CSS](https://tailwindcss.com/) - Styling

---