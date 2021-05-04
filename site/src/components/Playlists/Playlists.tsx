import { PlaylistsComponentProps } from '.';
import { Playlist, PlaylistCity } from '../Playlist';
import styles from './Playlists.module.css';

export const Playlists: React.FC<PlaylistsComponentProps> = ({
  playlists,
}: PlaylistsComponentProps) => (
  <div className={styles.playlists}>
    {playlists.map((p: PlaylistCity) => (
      <Playlist playlist={p} key={p.PlaylistId} />
    ))}
  </div>
);
