import { PlaylistsComponentProps } from '.';
import { Playlist, PlaylistType } from '../Playlist';
import styles from './Playlists.module.css';

export const Playlists: React.FC<PlaylistsComponentProps> = (props: PlaylistsComponentProps) => {
  return (
    <div className={styles.playlists}>
      {props.playlists.map((p: PlaylistType) => {
        return <Playlist playlist={p} key={p.PlaylistId} />;
      })}
    </div>
  );
};
