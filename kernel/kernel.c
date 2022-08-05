char change_video_memory()
{
    return '=';
}

int main()
{
    char *video_memory = (char*)0xb8000;
    *video_memory = change_video_memory();
    return 0;
}
