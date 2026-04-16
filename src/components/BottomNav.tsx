import { NavLink } from 'react-router-dom';

const navItems = [
  { to: '/', icon: '🏠', label: '홈' },
  { to: '/tests', icon: '🧪', label: '측정' },
  { to: '/training', icon: '🎮', label: '훈련' },
  { to: '/report', icon: '📊', label: '리포트' },
  { to: '/mypage', icon: '👤', label: 'MY' },
];

export default function BottomNav() {
  return (
    <nav className="bottom-nav">
      {navItems.map(({ to, icon, label }) => (
        <NavLink
          key={to}
          to={to}
          className={({ isActive }) =>
            `nav-item ${isActive ? 'nav-item--active' : ''}`
          }
        >
          <span className="nav-icon">{icon}</span>
          <span className="nav-label">{label}</span>
        </NavLink>
      ))}
    </nav>
  );
}
