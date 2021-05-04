export type PlaylistComponentProps = PlaylistProps;

export type PlaylistProps = {
  playlist: PlaylistCity;
};

export type PlaylistCity = {
  PlaylistId: string;
  Offset: number;
  PlaylistTitle: string;
  Area: string;
  MetroId: string;
  PhotoCredit: string;
};
