import styles from './Ducky.module.css';

export const Ducky: React.FC = () => (
  <div className={styles.Ducky}>
    <div className={styles.duck}>
      <div className={styles.duck__beak__top} />
      <div className={styles.duck__beak__bottom} />
      <div className={styles.duck__poof} />
      <div className={styles.duck__head} />
      <div className={styles.duck__eye} />
      <div className={styles.duck__iris} />
      <div className={styles.duck__body} />
      <div className={styles.duck__wing} />
    </div>
  </div>
);
