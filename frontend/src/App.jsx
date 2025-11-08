import { useState, useEffect } from 'react'
import { Shield, Github, Target, Activity, Lock, Globe, Database, TrendingUp, Moon, Sun, ExternalLink, ChevronDown } from 'lucide-react'

function App() {
  const [darkMode, setDarkMode] = useState(false)
  const [isVisible, setIsVisible] = useState(false)

  useEffect(() => {
    setIsVisible(true)
    // Check for saved theme preference or default to light mode
    const savedTheme = localStorage.getItem('theme')
    if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      setDarkMode(true)
      document.documentElement.classList.add('dark')
    }
  }, [])

  const toggleDarkMode = () => {
    setDarkMode(!darkMode)
    if (!darkMode) {
      document.documentElement.classList.add('dark')
      localStorage.setItem('theme', 'dark')
    } else {
      document.documentElement.classList.remove('dark')
      localStorage.setItem('theme', 'light')
    }
  }

  const scrollToSection = (sectionId) => {
    document.getElementById(sectionId)?.scrollIntoView({ behavior: 'smooth' })
  }

  return (
    <div className={`min-h-screen transition-colors duration-300 ${darkMode ? 'dark' : ''}`}>
      {/* Background */}
      <div className="fixed inset-0 bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-100 dark:from-slate-900 dark:via-slate-800 dark:to-indigo-900"></div>
      
      {/* Dark Mode Toggle */}
      <button
        onClick={toggleDarkMode}
        className="fixed top-4 right-4 z-50 p-3 rounded-full bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm border border-gray-200 dark:border-gray-700 hover:bg-white dark:hover:bg-slate-800 transition-all duration-300 shadow-lg"
        aria-label="Toggle dark mode"
      >
        {darkMode ? <Sun className="w-5 h-5 text-yellow-500" /> : <Moon className="w-5 h-5 text-slate-600" />}
      </button>

      {/* Main Content */}
      <div className="relative z-10">
        {/* Hero Section */}
        <section className="min-h-screen flex items-center justify-center text-center section-padding">
          <div className={`max-w-4xl mx-auto transform transition-all duration-1000 ${isVisible ? 'translate-y-0 opacity-100' : 'translate-y-10 opacity-0'}`}>
            {/* Logo/Shield Icon */}
            <div className="mb-8 flex justify-center">
              <div className="relative">
                <Shield className="w-24 h-24 text-blue-600 dark:text-blue-400 animate-bounce-subtle" />
                <div className="absolute inset-0 bg-blue-600/20 dark:bg-blue-400/20 rounded-full blur-xl"></div>
              </div>
            </div>
            
            {/* Title */}
            <h1 className="text-4xl md:text-6xl font-bold mb-6 text-gray-900 dark:text-white leading-tight">
              <span className="gradient-text">🛡️ Allyship Security Labs:</span>
              <br />
              <span className="text-gray-800 dark:text-gray-100">Advanced T-Pot Honeypot</span>
              <br />
              <span className="text-gray-700 dark:text-gray-200 text-3xl md:text-4xl">with Zero-Trust Architecture</span>
            </h1>
            
            {/* Subtitle */}
            <p className="text-xl md:text-2xl text-gray-600 dark:text-gray-300 mb-12 max-w-3xl mx-auto leading-relaxed">
              Advanced cybersecurity research project capturing real-world cyber attacks while maintaining enterprise-grade security controls
            </p>
            
            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12">
              <a
                href="https://github.com/robertpreshyl/allyshipseclabs-azure-tpot-threat-research"
                target="_blank"
                rel="noopener noreferrer"
                className="btn-primary"
              >
                <Github className="w-5 h-5 mr-2" />
                View on GitHub
                <ExternalLink className="w-4 h-4 ml-2" />
              </a>
              <button
                onClick={() => scrollToSection('overview')}
                className="inline-flex items-center px-6 py-3 border-2 border-blue-600 dark:border-blue-400 text-blue-600 dark:text-blue-400 font-medium rounded-lg hover:bg-blue-600 hover:text-white dark:hover:bg-blue-400 dark:hover:text-gray-900 transition-all duration-300"
              >
                Learn More
                <ChevronDown className="w-5 h-5 ml-2" />
              </button>
            </div>
            
            {/* Quick Stats */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-3xl mx-auto">
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-lg p-6 border border-gray-200 dark:border-gray-700 card-hover">
                <div className="text-3xl font-bold text-blue-600 dark:text-blue-400">451k+</div>
                <div className="text-gray-600 dark:text-gray-300">Attacks Captured</div>
              </div>
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-lg p-6 border border-gray-200 dark:border-gray-700 card-hover">
                <div className="text-3xl font-bold text-purple-600 dark:text-purple-400">18.3M+</div>
                <div className="text-gray-600 dark:text-gray-300">Host Events Monitored</div>
              </div>
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-lg p-6 border border-gray-200 dark:border-gray-700 card-hover">
                <div className="text-3xl font-bold text-green-600 dark:text-green-400">Zero-Trust</div>
                <div className="text-gray-600 dark:text-gray-300">Architecture</div>
              </div>
            </div>
          </div>
        </section>

        {/* Overview Section */}
        <section id="overview" className="section-padding bg-white/50 dark:bg-slate-800/50 backdrop-blur-sm">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-8 text-gray-900 dark:text-white">
              Project Overview
            </h2>
            <div className="text-lg text-gray-700 dark:text-gray-300 leading-relaxed space-y-6">
              <p>
                This research project deployed a <strong>T‑Pot honeypot on Microsoft Azure</strong> with enhanced security controls via <strong>NetBird</strong> and <strong>Elastic Fleet Agents</strong> to capture and analyze real‑world cyber attacks while maintaining a <strong>zero‑trust architecture</strong>.
              </p>
              <p>
                Over the final 7‑day window, the deployment captured <strong>451,000+ attack attempts</strong> across multiple honeypots. In parallel, Security Onion recorded <strong>18,300,651+ host telemetry events</strong> from the T‑Pot system and endpoints, providing comprehensive visibility into both external attacks and internal system behavior.
              </p>
              <p>
                NetBird's overlay network enabled secure, on‑the‑go access (including mobile) to dashboards and detections while maintaining enterprise-grade security controls and complete audit trails.
              </p>
            </div>
          </div>
        </section>

        {/* Key Highlights Section */}
        <section id="highlights" className="section-padding">
          <div className="max-w-6xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold mb-12 text-center text-gray-900 dark:text-white">
              Key Highlights & Achievements
            </h2>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {/* Attack Capture */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <Target className="w-12 h-12 text-red-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Attack Intelligence</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• 451,000+ attack attempts in 7 days</li>
                  <li>• Sentrypeer: ~225k SIP attacks</li>
                  <li>• Cowrie: ~213k SSH brute-force attempts</li>
                  <li>• Multiple honeypot types deployed</li>
                </ul>
              </div>

              {/* Host Monitoring */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <Activity className="w-12 h-12 text-blue-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Host Telemetry</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• 18.3M+ host events monitored</li>
                  <li>• Comprehensive behavioral analysis</li>
                  <li>• Process, file, and network monitoring</li>
                  <li>• Security Onion SIEM integration</li>
                </ul>
              </div>

              {/* Zero-Trust */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <Lock className="w-12 h-12 text-green-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Zero-Trust Access</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• NetBird WireGuard tunnels</li>
                  <li>• Secure mobile access capability</li>
                  <li>• Complete audit trails</li>
                  <li>• Policy-controlled access</li>
                </ul>
              </div>

              {/* Global Threat Intelligence */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <Globe className="w-12 h-12 text-purple-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Global Intelligence</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• Romania, US, Netherlands top sources</li>
                  <li>• China and Hong Kong significant</li>
                  <li>• SIP attacks dominated (port 5060)</li>
                  <li>• OSINT enrichment via SpiderFoot</li>
                </ul>
              </div>

              {/* Data Storage */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <Database className="w-12 h-12 text-orange-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Data Management</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• Azure Blob Storage integration</li>
                  <li>• Durable data retention</li>
                  <li>• Anonymized research datasets</li>
                  <li>• GDPR compliant processing</li>
                </ul>
              </div>

              {/* Advanced Analytics */}
              <div className="bg-white/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-xl p-8 border border-gray-200 dark:border-gray-700 card-hover">
                <TrendingUp className="w-12 h-12 text-indigo-500 mb-4" />
                <h3 className="text-xl font-semibold mb-3 text-gray-900 dark:text-white">Advanced Analytics</h3>
                <ul className="text-gray-700 dark:text-gray-300 space-y-2">
                  <li>• Elastic Stack integration</li>
                  <li>• Real-time attack visualization</li>
                  <li>• Behavioral pattern analysis</li>
                  <li>• Threat intelligence correlation</li>
                </ul>
              </div>
            </div>
          </div>
        </section>

        {/* Call to Action Section */}
        <section className="section-padding bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-700 dark:to-purple-700">
          <div className="max-w-4xl mx-auto text-center text-white">
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Explore the Research
            </h2>
            <p className="text-xl mb-8 opacity-90">
              Dive deep into the comprehensive documentation, attack analysis, and technical implementation details of this advanced cybersecurity research project.
            </p>
            <a
              href="https://github.com/robertpreshyl/allyshipseclabs-azure-tpot-threat-research"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center px-8 py-4 bg-white text-blue-600 font-semibold rounded-lg hover:bg-gray-100 transition-all duration-300 transform hover:scale-105 shadow-lg"
            >
              <Github className="w-6 h-6 mr-3" />
              View Full Documentation
              <ExternalLink className="w-5 h-5 ml-3" />
            </a>
          </div>
        </section>

        {/* Footer */}
        <footer className="bg-slate-900 dark:bg-slate-950 text-white py-8">
          <div className="max-w-4xl mx-auto text-center px-4">
            <div className="flex items-center justify-center mb-4">
              <Shield className="w-8 h-8 text-blue-400 mr-3" />
              <span className="text-xl font-semibold">Allyship Security Labs</span>
            </div>
            <p className="text-gray-400 mb-4">
              Building a More Secure Digital Future
            </p>
            <p className="text-sm text-gray-500">
              © 2025 Allyship Security Labs – Research Project
            </p>
            <p className="text-xs text-gray-600 mt-2">
              All research conducted in compliance with applicable laws and ethical standards
            </p>
          </div>
        </footer>
      </div>
    </div>
  )
}

export default App





