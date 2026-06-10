CREATE TABLE public.saved_posts (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  text TEXT NOT NULL DEFAULT '',
  image_base64 TEXT,
  button_text TEXT,
  button_url TEXT,
  button_color TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

GRANT SELECT, INSERT, UPDATE, DELETE ON public.saved_posts TO anon, authenticated;
GRANT ALL ON public.saved_posts TO service_role;

ALTER TABLE public.saved_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read" ON public.saved_posts FOR SELECT USING (true);
CREATE POLICY "public insert" ON public.saved_posts FOR INSERT WITH CHECK (true);
CREATE POLICY "public update" ON public.saved_posts FOR UPDATE USING (true) WITH CHECK (true);
CREATE POLICY "public delete" ON public.saved_posts FOR DELETE USING (true);

CREATE OR REPLACE FUNCTION public.update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE TRIGGER update_saved_posts_updated_at BEFORE UPDATE ON public.saved_posts
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();