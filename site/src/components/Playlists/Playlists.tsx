import * as playlists from './Playlists.json';
import { Playlist } from '../Playlist';
import styles from './Playlists.module.css';

export const Playlists: React.FC = () => {
  return (
    <div className={styles.playlists}>
      {playlists.map((p) => {
        return (
          <>
            <Playlist playlist={p} />
          </>
        );
      })}
    </div>
  );
};
