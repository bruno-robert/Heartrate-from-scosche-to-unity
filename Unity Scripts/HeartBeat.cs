using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeartBeat : MonoBehaviour
{
    bool beat = false;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (beat == false)
        StartCoroutine(Beat());
    }

    IEnumerator Beat()
    {
        beat = true;
        yield return new WaitForSeconds(1f);
        //gameObject.transform.localScale += new Vector3(0.001f, 0.001f, 0.001f);
        Grow();
        yield return new WaitForSeconds(0.3f);
        //gameObject.transform.localScale -= new Vector3(0.001f, 0.001f, 0.001f);
        Shrink();
        yield return new WaitForSeconds(0.3f);
        //gameObject.transform.localScale += new Vector3(0.001f, 0.001f, 0.001f);
        Grow();
        yield return new WaitForSeconds(0.3f);
        //gameObject.transform.localScale -= new Vector3(0.001f, 0.001f, 0.001f);
        Shrink();
        //yield return new WaitForSeconds(1);
        beat = false;

    }

    void Grow()
    {
        gameObject.transform.localScale += new Vector3(0.001f, 0.001f, 0.001f);


    }

    void Shrink()
    {
        gameObject.transform.localScale -= new Vector3(0.001f, 0.001f, 0.001f);

    }
}
