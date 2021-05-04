import { SearchComponentProps } from '.';
import styles from './Search.module.css';

export const Search: React.FC<SearchComponentProps> = ({
  value,
  onChange,
  onReset,
}: SearchComponentProps) => (
  <div className={styles.searchContainer}>
    <input
      type="text"
      value={value}
      onChange={onChange}
      placeholder="Search"
      className={styles.search}
    />
    <button type="button" className={styles.resetButton} onClick={onReset}>
      <svg
        width="48"
        height="48"
        viewBox="0 0 48 48"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          d="M7.02332 7.05171C7.60911 6.46592 8.55886 6.46592 9.14464 7.05171L23.9996 21.9066L38.8545 7.05171C39.4403 6.46592 40.39 6.46592 40.9758 7.05171C41.5616 7.63749 41.5616 8.58724 40.9758 9.17303L26.1209 24.0279L40.9199 38.827C41.5057 39.4128 41.5057 40.3625 40.9199 40.9483C40.3341 41.5341 39.3844 41.5341 38.7986 40.9483L23.9996 26.1493L9.20054 40.9483C8.61475 41.5341 7.665 41.5341 7.07922 40.9483C6.49343 40.3625 6.49343 39.4128 7.07922 38.827L21.8782 24.0279L7.02332 9.17303C6.43754 8.58724 6.43754 7.63749 7.02332 7.05171Z"
          fill="#212121"
        />
      </svg>
    </button>
  </div>
);
