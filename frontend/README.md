# 🛡️ Allyship Security Labs Website

Modern, responsive one-page website for the Advanced T-Pot Honeypot Research Project.

## 🚀 Quick Start

### Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

### Production Build

```bash
# Build for production
npm run build

# Preview production build
npm run preview
```

## 🌐 Deployment on Cloudflare Pages

### Method 1: Git Integration (Recommended)

1. Push this `frontend` directory to your GitHub repository
2. Go to [Cloudflare Pages](https://pages.cloudflare.com/)
3. Click "Create a project" → "Connect to Git"
4. Select your repository
5. Configure build settings:
   - **Build command**: `npm run build`
   - **Build output directory**: `dist`
   - **Root directory**: `frontend` (if deploying from subdirectory)
6. Click "Save and Deploy"

### Method 2: Direct Upload

```bash
# Build the project
npm run build

# Upload the dist folder contents to Cloudflare Pages dashboard
```

### Build Settings for Cloudflare Pages

- **Framework preset**: Vite
- **Build command**: `npm run build`
- **Build output directory**: `dist`
- **Root directory**: `frontend` (if this is a subdirectory)
- **Node.js version**: 18.x or later

## 🎨 Features

- ✅ **Modern React + TailwindCSS**: Clean, professional design
- ✅ **Responsive Design**: Works on desktop, tablet, and mobile
- ✅ **Dark Mode Support**: Automatic system preference detection
- ✅ **Smooth Animations**: Subtle hover effects and transitions
- ✅ **SEO Optimized**: Meta tags and Open Graph support
- ✅ **Performance Optimized**: Vite build system for fast loading
- ✅ **Accessibility**: Proper ARIA labels and keyboard navigation

## 🛠️ Tech Stack

- **React 18**: Modern React with hooks
- **TailwindCSS**: Utility-first CSS framework
- **Vite**: Fast build tool and dev server
- **Lucide React**: Beautiful, customizable icons
- **PostCSS**: CSS processing with autoprefixer

## 📁 Project Structure

```
frontend/
├── public/
├── src/
│   ├── App.jsx          # Main application component
│   ├── main.jsx         # React entry point
│   └── index.css        # Global styles with Tailwind
├── index.html           # HTML template
├── package.json         # Dependencies and scripts
├── tailwind.config.js   # Tailwind configuration
├── vite.config.js       # Vite configuration
└── README.md           # This file
```

## 🎯 Key Sections

1. **Hero Section**: Project title, overview, and key statistics
2. **Project Overview**: Detailed description of the research
3. **Key Highlights**: Six main achievement categories with icons
4. **Call to Action**: GitHub repository link
5. **Footer**: Copyright and legal information

## 🔧 Customization

### Colors
The color scheme is defined in `tailwind.config.js` and can be easily customized:

```js
colors: {
  primary: { /* Blue color palette */ },
  dark: { /* Dark mode color palette */ }
}
```

### Content
All content is in `src/App.jsx` and can be easily modified to match your needs.

### Styling
Custom components are defined in `src/index.css` using Tailwind's `@layer` directive.

## 📱 Browser Support

- Chrome (latest)
- Firefox (latest)  
- Safari (latest)
- Edge (latest)

## 📄 License

This website code is part of the Allyship Security Labs research project.

---

**© 2025 Allyship Security Labs – Research Project**





